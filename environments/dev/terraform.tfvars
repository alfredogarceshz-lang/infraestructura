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
