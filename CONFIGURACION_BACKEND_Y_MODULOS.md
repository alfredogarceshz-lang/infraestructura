# Configuración del Backend GCS y Activación de Módulos

## 1. Backend GCS - Configuración Unificada

### Estructura del Bucket

Usa **un solo bucket de estado GCS** para todos los ambientes con prefijos separados:

```
Bucket: gim-tfstate
├── environments/dev/
├── environments/qa/
└── environments/prod/
```

### Crear el Bucket (una sola vez)

```powershell
# En el proyecto de infraestructura o dev
gsutil mb -l us-central1 gs://gim-tfstate

# Habilitar versionado
gsutil versioning set on gs://gim-tfstate
```

### Inicializar Terraform por Ambiente

```powershell
# Development
cd infraestructura/environments/dev
terraform init \
  -backend-config="bucket=gim-tfstate" \
  -backend-config="prefix=environments/dev"

# QA
cd infraestructura/environments/qa
terraform init \
  -backend-config="bucket=gim-tfstate" \
  -backend-config="prefix=environments/qa"

# Production
cd infraestructura/environments/prod
terraform init \
  -backend-config="bucket=gim-tfstate" \
  -backend-config="prefix=environments/prod"
```

## 2. Activar Módulos en cada Ambiente

Los módulos están desactivados por defecto (`enable_* = false`).

### Para activar un módulo, edita el archivo `terraform.tfvars` del ambiente:

#### Development: `environments/dev/terraform.tfvars`

```hcl
# Cambiar de false a true para activar cada servicio
enable_composer  = true   # Descomenta para Cloud Composer
enable_dataproc  = true   # Descomenta para Dataproc
enable_dataplex  = true   # Descomenta para Dataplex
enable_vpn       = true   # Descomenta para VPN/Networking
enable_pubsub    = true   # Descomenta para Pub/Sub
enable_cloud_run = true   # Descomenta para Cloud Run
```

Aplica lo mismo a `environments/qa/terraform.tfvars` y `environments/prod/terraform.tfvars`.

## 3. Módulos Ahora Disponibles (Recursos Reales)

### Composer
- **Recurso**: `google_composer_environment`
- **Configuración**: Composer 2 Stable
- **Outputs**: `composer_name`, `composer_id`, `gke_cluster`

### Dataproc
- **Recurso**: `google_dataproc_cluster`
- **Configuración**: 1 master + 2 workers (n1-standard-2)
- **Outputs**: `cluster_name`, `cluster_id`

### Dataplex
- **Recurso**: `google_dataplex_lake`
- **Outputs**: `lake_id`, `lake_name`

### Pub/Sub
- **Recursos**: `google_pubsub_topic` + `google_pubsub_subscription`
- **Outputs**: `topic_name`, `subscription_name`

### Cloud Run
- **Recurso**: `google_cloud_run_service`
- **Imagen de ejemplo**: `gcr.io/cloudrun/hello`
- **Outputs**: `service_name`, `service_url`

### VPN/Networking
- **Recursos**: `google_compute_network` + `google_compute_subnetwork` + `google_compute_vpn_gateway`
- **Outputs**: `network_name`, `subnet_name`, `gateway_id`

## 4. Validar Cambios

Antes de aplicar:

```powershell
cd infraestructura/environments/dev
terraform validate
terraform plan
```

## 5. Aplicar Configuración

```powershell
cd infraestructura/environments/dev
terraform plan -var-file=terraform.tfvars -input=false
terraform apply -var-file=terraform.tfvars -auto-approve -input=false
```

## 6. Notas Importantes

- El backend GCS se crea una sola vez con el prefijo del ambiente.
- Los módulos son idempotentes: puedes cambiar `enable_*` sin perder el estado.
- Los recursos de Composer, Dataproc y Dataplex pueden tardar varios minutos en crearse.
- Ajusta las configuraciones de máquina, número de nodos, etc., según tus necesidades.

## 7. GitHub Actions

Los workflows ya están actualizados para:
1. Validar en PR/push
2. Aplicar cambios en `develop`, `qa`, `prod`
3. Usar variables `TFSTATE_BUCKET` para el nombre del bucket

Asegúrate de configurar esta variable en los settings de GitHub:
- `TFSTATE_BUCKET = gim-tfstate`
