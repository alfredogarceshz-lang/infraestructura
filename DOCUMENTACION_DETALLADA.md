# Documentación detallada del proyecto Terraform GCP

## 1. Resumen general
Este proyecto es una base de infraestructura Terraform para GCP con soporte multiambiente. La estructura actual contiene tres entornos:
- `environments/dev`
- `environments/qa`
- `environments/prod`

Cada entorno usa módulos comunes definidos en `modules/`.

## 2. Estructura principal

- `environments/*`: configuración por ambiente.
  - `backend.tf`: datos del backend remoto GCS.
  - `providers.tf`: proveedor `google` de GCP.
  - `main.tf`: invocación de módulos.
  - `locals.tf`: etiquetas comunes y variables locales.
  - `outputs.tf`: salidas de Terraform.
  - `terraform.tfvars`: valores concretos del ambiente.
  - `variables.tf`: definición de variables del entorno.
  - `versions.tf`: versiones de Terraform y proveedor.
- `modules/*`: módulos reutilizables.
- `scripts/bootstrap.ps1`: script PowerShell para habilitar APIs y crear bucket de state.
- `README.md`: explicación general y comandos de uso.
- `.github/workflows`: workflows de GitHub Actions.

## 3. Cómo funciona cada ambiente

### 3.1 `backend.tf`
Contiene:
```hcl
terraform {
  backend "gcs" {}
}
```

Esto declara que el estado remoto usará Google Cloud Storage. El bucket y el prefijo no están en el archivo, por lo que deben pasarse al inicializar Terraform:
- `-backend-config="bucket=..."`
- `-backend-config="prefix=..."`

### 3.2 `providers.tf`
Define el proveedor de GCP:
```hcl
provider "google" {
  project = var.project_id
  region  = var.region
}
```

Usa el proyecto y región definidos en `terraform.tfvars`.

### 3.3 `locals.tf`
Define etiquetas comunes:
```hcl
locals {
  common_labels = merge(var.labels, {
    environment = var.environment
    managed_by  = "terraform"
    repository  = "terraform-gcp"
  })
}
```

Estas etiquetas se reusan en los recursos definidos en módulos.

### 3.4 `main.tf`
Este es el archivo más importante por ambiente. En `environments/dev/main.tf` se invocan módulos:
- `module "naming"`
- `module "iam"`
- `module "storage"`
- `module "bigquery"`
- `module "secret_manager"`
- `module "composer"`
- `module "dataproc"`
- `module "dataplex"`
- `module "vpn"`
- `module "pubsub"`
- `module "cloud_run"`

El flujo general es:
1. `naming` genera nombres de proyecto, buckets, service accounts y recursos derivados.
2. `iam` crea service accounts y les asigna roles.
3. `storage` crea buckets de landing/bronze/silver/gold.
4. `bigquery` crea datasets y una tabla de ejemplo.
5. `secret_manager` crea un secreto con el valor sensible.
6. Los demás módulos (`composer`, `dataproc`, `dataplex`, `vpn`, `pubsub`, `cloud_run`) actualmente no crean recursos GCP reales.

### 3.5 `outputs.tf`
Expone valores útiles:
- `project_id`
- `buckets`
- `service_accounts`
- `datasets`
- `secret_name`

Esto permite ver fácilmente los resultados después de `terraform apply`.

### 3.6 `terraform.tfvars`
Define los valores concretos del ambiente. Ejemplo en `dev`:
- `environment = "dev"`
- `project_id = "gim-data-dev"`
- `region = "us-central1"`
- `domain = "enterprise"`
- `labels` con `owner`, `system`, `purpose`
- `datasets` con 4 datasets: `cfg_platform`, `brz_hubspot`, `slv_customer`, `gld_sales`
- `example_table_id = "contacts"`
- `secret_value = "replace-me-dev"`
- Todos los flags `enable_* = false`

Los otros ambientes (`qa`, `prod`) son equivalentes salvo `environment`, `project_id` y `secret_value`.

## 4. Qué hace cada módulo

### 4.1 `modules/naming`
Genera nombres de recursos mediante `locals`:
- `project_id = "gim-data-${var.environment}"`
- buckets: `gim-cs-landing-${environment}`, `gim-cs-bronze-${environment}`, `gim-cs-silver-${environment}`, `gim-cs-gold-${environment}`
- `composer_name`
- `dataplex_lake`
- service accounts: `sa-dataproc-processing-${environment}`, `sa-composer-orchestration-${environment}`

No crea proyectos, solo define nombres y salidas.

### 4.2 `modules/iam`
Crea service accounts y asignaciones IAM:
- `google_service_account.sa` por cada valor en `service_accounts`
- `google_project_iam_member.sa_roles` asigna los roles listados en `project_roles`

En `dev/main.tf`, asigna:
- `roles/dataproc.worker` y `roles/storage.objectAdmin` al SA de Dataproc.
- `roles/composer.worker` y `roles/secretmanager.secretAccessor` al SA de Composer.

### 4.3 `modules/storage`
Crea buckets GCS con `google_storage_bucket.lakehouse` para cada capa:
- landing
- bronze
- silver
- gold

Propiedades:
- `uniform_bucket_level_access = true`
- versioning enabled
- lifecycle rule: después de 90 días se cambia a `NEARLINE`
- etiquetas combinadas con `var.labels` y `layer = each.key`

### 4.4 `modules/bigquery`
Crea datasets BQ y una tabla de ejemplo:
- `google_bigquery_dataset.datasets` para cada dataset en `var.datasets`
- `google_bigquery_table.example` en el dataset `brz_hubspot` con esquema mínima

Este módulo valida que la configuración BQ funciona.

### 4.5 `modules/secret_manager`
Crea un secreto en Secret Manager:
- `google_secret_manager_secret.this`
- `google_secret_manager_secret_version.v1`

El valor del secreto se toma de `var.secret_value`.

### 4.6 `modules/composer`, `modules/dataproc`, `modules/dataplex`, `modules/pubsub`, `modules/cloud_run`, `modules/vpn`
Estos módulos no provisionan recursos reales. Solo contienen un recurso `terraform_data`, que es un placeholder de Terraform, no un recurso de GCP.

Esto significa que, aunque el `main.tf` del ambiente invoca estos módulos, en el estado actual no se crearán servicios de Composer, Dataproc, Dataplex, Pub/Sub, Cloud Run ni VPN.

## 5. GitHub Actions y workflows

Hay dos workflows:
- `infraestructura/.github/workflows/terraform-validate.yml`
- `infraestructura/.github/workflows/terraform-apply.yml`

### 5.1 `terraform-validate.yml`
Valida en `pull_request` y `push` a ramas `develop`, `qa`, `prod`.
Flujo:
1. checkout
2. setup Terraform
3. determina `ENV_DIR` según rama
4. `terraform fmt -check -recursive`
5. `terraform init` con backend GCS
6. `terraform validate`
7. `terraform plan`

### 5.2 `terraform-apply.yml`
Ejecuta deploy en `push` a `develop`, `qa`, `prod` o manualmente.
Flujo:
1. checkout
2. setup Terraform
3. bloquea apply para ramas no permitidas
4. determina `ENV_DIR`
5. `terraform init`
6. `terraform apply`

### 5.3 Problema detectado en los workflows
Los archivos usan rutas relativas `terraform-gcp/${{ env.ENV_DIR }}`.
En la estructura actual del repositorio, la carpeta con Terraform se llama `infraestructura`, no `terraform-gcp`.
Esto implica que los workflows no funcionarán a menos que:
- el repositorio real tenga una carpeta `terraform-gcp`, o
- se corrijan las rutas a `infraestructura/${{ env.ENV_DIR }}`.

Además, el `README.md` también usa `terraform-gcp`, lo cual está inconsistente con la carpeta actual.

## 6. Script de bootstrap

`infraestructura/scripts/bootstrap.ps1` hace:
1. habilita APIs necesarias con `gcloud services enable`
2. crea el bucket de estado con `gsutil mb`
3. habilita versioning con `gsutil versioning set on`

APIs incluidas:
- iam.googleapis.com
- cloudresourcemanager.googleapis.com
- serviceusage.googleapis.com
- compute.googleapis.com
- storage.googleapis.com
- secretmanager.googleapis.com
- bigquery.googleapis.com
- composer.googleapis.com
- dataproc.googleapis.com
- dataplex.googleapis.com

Este script prepara el proyecto para almacenar el estado remoto.

## 7. Estado actual del proyecto: opinión y calidad

### Puntos positivos
- Buena separación por entorno (`dev`, `qa`, `prod`).
- Módulos claros y reutilizables.
- Uso correcto de variables, outputs y etiquetas.
- Gestión de `backend` remoto mediante GCS.
- Validación local posible con `terraform fmt`, `terraform validate`.

### Puntos a mejorar / corregir
1. `modules/composer`, `modules/dataproc`, `modules/dataplex`, `modules/pubsub`, `modules/cloud_run`, `modules/vpn` no crean recursos GCP reales.
   - Son placeholders y no funcionan como módulos productivos.
2. Workflows `.github/workflows` usan ruta `terraform-gcp/` en lugar de la carpeta actual.
3. `README.md` describe `terraform-gcp/` en lugar de `infraestructura/`.
4. El backend `gcs` está declarado vacío y necesita `-backend-config` en tiempo de inicialización.
5. `secret_value` en los `terraform.tfvars` es un valor de muestra `replace-me-*` y no debe usarse en producción.

## 8. Qué debes modificar para ponerlo a andar

### 8.1 Ajustar rutas en workflows y README
- Cambiar `terraform-gcp/${{ env.ENV_DIR }}` por `infraestructura/${{ env.ENV_DIR }}` en los workflows.
- Cambiar ejemplos de `cd terraform-gcp/environments/dev` por `cd infraestructura/environments/dev` en `README.md`.

### 8.2 Inicializar backend remoto
Tienes que crear un bucket de estado y luego ejecutar:
```powershell
cd infraestructura/environments/dev
terraform init -backend-config="bucket=TU_BUCKET_STATE" -backend-config="prefix=environments/dev"
```

### 8.3 Proveer autenticación
- Local: `gcloud auth application-default login`
- CI: configura GitHub Actions OIDC con `id-token: write` y `TFSTATE_BUCKET`

### 8.4 Habilitar APIs y crear bucket de estado
Usa `infraestructura/scripts/bootstrap.ps1` o realiza manualmente.

### 8.5 Ajustar variables de entorno
- Cambia `secret_value` por un secreto real o gestiona el secreto fuera del repo.
- Si quieres crear `composer`, `dataproc`, `dataplex`, `pubsub`, `cloud_run`, activa `enable_* = true` y completa los módulos con recursos reales.

### 8.6 Revisar módulos incompletos
- `composer`: debe crear `google_composer_environment`.
- `dataproc`: debe crear `google_dataproc_cluster` o recursos equivalentes.
- `dataplex`: debe crear `google_dataplex_lake`/`google_dataplex_asset`.
- `pubsub`: debe crear `google_pubsub_topic` y `google_pubsub_subscription`.
- `cloud_run`: debe crear `google_cloud_run_service`.
- `vpn`: debe crear recursos de red/VPN de GCP.

## 9. Pasos para validar localmente antes de aplicar

1. Instala Terraform >= 1.7, gcloud, gsutil.
2. En cada ambiente:
   - `terraform fmt -check -recursive`
   - `terraform init -backend=false`
   - `terraform validate`
3. Para backend remoto real:
   - `terraform init -backend-config="bucket=..." -backend-config="prefix=environments/dev"`
   - `terraform plan -var-file=terraform.tfvars -input=false`

## 10. Conclusión

El proyecto está bien planteado como un skeleton de infraestructura multiambiente. Sin embargo, no está listo para desplegar todo lo que declara en `main.tf` porque varios módulos son placeholders.

Para ponerlo verdaderamente en marcha, debes corregir las rutas de los workflows/README y completar los módulos con recursos de GCP reales, además de configurar el backend remoto y las credenciales.
