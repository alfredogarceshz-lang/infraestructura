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
  example_table = {
    dataset_id = "brz_hubspot"
    table_id   = var.example_table_id
  }
}

module "secret_manager" {
  source = "../../modules/secret_manager"

  project_id    = module.naming.project_id
  secret_id     = "sm-hubspot-token-${var.environment}"
  secret_value  = var.secret_value
}

module "composer" {
  source = "../../modules/composer"

  create        = var.enable_composer
  project_id    = module.naming.project_id
  region        = var.region
  composer_name = module.naming.composer_name
  service_account_email = module.iam.composer_service_account_email
  labels        = local.common_labels

  depends_on = [module.iam]
}

module "dataproc" {
  source = "../../modules/dataproc"

  create                = var.enable_dataproc
  project_id            = module.naming.project_id
  region                = var.region
  environment           = var.environment
  labels                = local.common_labels
  service_account_email = module.iam.service_account_emails["sa-dataproc-ace-${var.environment}"]
  main_python_file_uri  = "gs://${module.naming.bucket_bronze}/dataproc/jobs/main.py"
}

module "dataplex" {
  source = "../../modules/dataplex"

  create     = var.enable_dataplex
  project_id = module.naming.project_id
  region     = var.region
  environment = var.environment
  labels      = local.common_labels
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
