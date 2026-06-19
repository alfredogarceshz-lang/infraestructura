environment = "prod"
project_id  = "gim-data-prod"
region      = "us-central1"
domain      = "enterprise"

labels = {
  owner   = "data-platform"
  system  = "gim"
  purpose = "analytics"
}

datasets = {
  cfg_platform = "Configuracion de plataforma"
  brz_hubspot  = "Datos crudos de HubSpot"
  slv_customer = "Datos estandarizados de clientes"
  gld_sales    = "Modelo de ventas curado"
}

example_table_id = "contacts"
secret_value     = "replace-me-prod"

enable_composer  = false
enable_dataproc  = false
enable_dataplex  = false
enable_vpn       = false
enable_pubsub    = false
enable_cloud_run = false
