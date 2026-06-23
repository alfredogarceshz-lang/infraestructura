environment = "dev"
project_id  = "gim-data-dev"
region      = "us-central1"
domain      = "enterprise"

labels = {
  owner   = "data-platform"
  system  = "gim"
  purpose = "analytics"
}

datasets = {  
  gim_dataset_brz_dev  = "Datos crudos (bronze)"
  gim_dataset_slv_dev = "Datos estandarizados (silver)"
  gim_dataset_gld_dev = "Modelo curado (gold)"
}

secret_value     = "replace-me-dev"

enable_composer  = false
enable_dataproc  = false
enable_dataplex  = false
enable_vpn       = false
enable_pubsub    = false
enable_cloud_run = false

# Configuración de Composer 3 (Managed Airflow) — preset SMALL
composer_environment_size     = "ENVIRONMENT_SIZE_SMALL"

composer_scheduler_cpu        = 0.5
composer_scheduler_memory_gb  = 1.875
composer_scheduler_storage_gb = 1
composer_scheduler_count      = 1

composer_worker_cpu           = 0.5
composer_worker_memory_gb     = 1.875
composer_worker_storage_gb    = 1
composer_worker_min_count     = 1
composer_worker_max_count     = 2

composer_web_server_cpu           = 0.5
composer_web_server_memory_gb     = 1.875
composer_web_server_storage_gb    = 1
