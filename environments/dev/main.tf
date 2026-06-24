module "naming" {
  source = "../../modules/naming"

  environment = var.environment
  region      = var.region
  domain      = var.domain
}

module "iam" {
  source = "../../modules/iam"

  project_id = module.naming.project_id
  service_accounts = [
    "sa-terraform-ace-${var.environment}",
    "sa-composer-ace-${var.environment}",
    "sa-dataproc-ace-${var.environment}",
    "sa-dataform-ace-${var.environment}",
    "sa-dataplex-ace-${var.environment}",
    "sa-cf-ace-${var.environment}"
  ]
  project_roles = {
    ("sa-terraform-ace-${var.environment}") = [
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountUser",
      "roles/iam.securityAdmin",
      "roles/resourcemanager.projectIamAdmin",
      "roles/serviceusage.serviceUsageAdmin",
      "roles/bigquery.admin",
      "roles/storage.admin",
      "roles/composer.admin",
      "roles/dataproc.admin",
      "roles/dataplex.admin",
      "roles/pubsub.admin",
      "roles/secretmanager.admin",
      "roles/monitoring.admin",
      "roles/logging.admin",
      "roles/artifactregistry.admin"
    ]

    ("sa-composer-ace-${var.environment}") = [
      "roles/composer.worker",
      "roles/storage.objectAdmin",
      "roles/bigquery.jobUser",
      "roles/bigquery.dataEditor",
      "roles/dataproc.editor",
      "roles/dataplex.editor",
      "roles/pubsub.publisher",
      "roles/pubsub.subscriber",
      "roles/secretmanager.secretAccessor",
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter"
    ]

    ("sa-dataproc-ace-${var.environment}") = [
      "roles/dataproc.worker",
      "roles/storage.objectAdmin",
      "roles/bigquery.jobUser",
      "roles/bigquery.dataEditor",
      "roles/bigquery.readSessionUser",
      "roles/dataplex.editor",
      "roles/pubsub.subscriber",
      "roles/secretmanager.secretAccessor",
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter"
    ]

    ("sa-dataform-ace-${var.environment}") = [
      "roles/dataform.editor",
      "roles/bigquery.jobUser",
      "roles/bigquery.dataEditor",
      "roles/bigquery.dataViewer",
      "roles/logging.logWriter"
    ]

    ("sa-dataplex-ace-${var.environment}") = [
      "roles/dataplex.editor",
      "roles/bigquery.metadataViewer",
      "roles/storage.objectViewer",
      "roles/datacatalog.viewer",
      "roles/logging.logWriter"
    ]

    ("sa-cf-ace-${var.environment}") = [
      "roles/storage.objectAdmin",
      "roles/pubsub.publisher",
      "roles/pubsub.subscriber",
      "roles/secretmanager.secretAccessor",
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter"
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
  external_tables = local.external_tables
  iceberg_tables  = local.iceberg_tables

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
  service_account_email = module.iam.composer_service_account_email
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

  depends_on = [module.iam]
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
