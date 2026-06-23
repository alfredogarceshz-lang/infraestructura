module "naming" {
  source = "../../modules/naming"

  environment = var.environment
  region      = var.region
  domain      = var.domain
}

module "iam" {
  source = "../../modules/iam"

  project_id       = module.naming.project_id
  service_accounts = [module.naming.service_account_dataproc, module.naming.service_account_composer]
  project_roles = {
    (module.naming.service_account_dataproc) = [
      "roles/dataproc.worker",
      "roles/storage.objectAdmin"
    ]
    (module.naming.service_account_composer) = [
      "roles/composer.worker",
      "roles/secretmanager.secretAccessor"
    ]
  }
}

module "storage" {
  source = "../../modules/storage"

  project_id = module.naming.project_id
  region     = var.region
  labels     = local.common_labels
  bucket_names = {
    landing = module.naming.bucket_landing
    bronze  = module.naming.bucket_bronze
    silver  = module.naming.bucket_silver
    gold    = module.naming.bucket_gold
  }
}

module "bigquery" {
  source = "../../modules/bigquery"

  project_id = module.naming.project_id
  location   = var.region
  datasets   = var.datasets
  external_tables = var.external_tables

}

module "secret_manager" {
  source = "../../modules/secret_manager"

  project_id    = module.naming.project_id
  secret_id     = "sm-hubspot-token-${var.environment}"
  secret_value  = var.secret_value
}

module "composer" {
  source = "../../modules/composer"

  create                = var.enable_composer
  project_id            = module.naming.project_id
  region                = var.region
  composer_name         = module.naming.composer_name
  labels                = local.common_labels
  environment_size      = var.composer_environment_size
  scheduler_cpu         = var.composer_scheduler_cpu
  scheduler_memory_gb   = var.composer_scheduler_memory_gb
  scheduler_storage_gb  = var.composer_scheduler_storage_gb
  scheduler_count       = var.composer_scheduler_count
  worker_cpu            = var.composer_worker_cpu
  worker_memory_gb      = var.composer_worker_memory_gb
  worker_storage_gb     = var.composer_worker_storage_gb
  worker_min_count      = var.composer_worker_min_count
  worker_max_count      = var.composer_worker_max_count
  web_server_cpu        = var.composer_web_server_cpu
  web_server_memory_gb  = var.composer_web_server_memory_gb
  web_server_storage_gb = var.composer_web_server_storage_gb
}

module "dataproc" {
  source = "../../modules/dataproc"

  create      = var.enable_dataproc
  project_id  = module.naming.project_id
  region      = var.region
  environment = var.environment
}

module "dataplex" {
  source = "../../modules/dataplex"

  create     = var.enable_dataplex
  project_id = module.naming.project_id
  region     = var.region
  lake_name  = module.naming.dataplex_lake
}

module "vpn" {
  source = "../../modules/vpn"

  create       = var.enable_vpn
  project_id   = module.naming.project_id
  region       = var.region
  network_name = "default"
}

module "pubsub" {
  source = "../../modules/pubsub"

  create            = var.enable_pubsub
  project_id        = module.naming.project_id
  topic_name        = "topic-hubspot-contacts"
  subscription_name = "sub-hubspot-contacts-${var.environment}"
}

module "cloud_run" {
  source = "../../modules/cloud_run"

  create       = var.enable_cloud_run
  project_id   = module.naming.project_id
  region       = var.region
  service_name = "gim-cloudrun-${var.environment}"
}
