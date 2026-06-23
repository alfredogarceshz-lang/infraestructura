resource "google_composer_environment" "main" {
  count = var.create ? 1 : 0

  project = var.project_id
  name    = var.composer_name
  region  = var.region
  labels  = var.labels

  config {
    # Composer 3 usa una imagen de la familia composer-3-airflow-2.
    # El sufijo "-airflow-2" indica la versión de Airflow compatible.
    software_config {
      image_version = "composer-3-airflow-2"
    }

    # En Composer 3 el tamaño del ambiente controla la escala global
    # del plano de control (base scheduling, API server, etc.).
    environment_size = var.environment_size

    # workloads_config reemplaza node_config: Composer 3 es Managed Airflow
    # (sin GKE expuesto), por lo que se configura cada componente de Airflow
    # de forma individual en lugar de aprovisionar nodos de VM.
    workloads_config {
      scheduler {
        cpu        = var.scheduler_cpu
        memory_gb  = var.scheduler_memory_gb
        storage_gb = var.scheduler_storage_gb
        count      = var.scheduler_count
      }

      worker {
        cpu        = var.worker_cpu
        memory_gb  = var.worker_memory_gb
        storage_gb = var.worker_storage_gb
        min_count  = var.worker_min_count
        max_count  = var.worker_max_count
      }

      web_server {
        cpu        = var.web_server_cpu
        memory_gb  = var.web_server_memory_gb
        storage_gb = var.web_server_storage_gb
      }
    }
  }
}
