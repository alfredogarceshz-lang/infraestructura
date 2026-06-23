locals {
  project_id = "${var.project_prefix}-${var.environment}"

  bucket_landing = "gim-cs-landing-${var.environment}"
  bucket_bronze  = "gim-cs-brz-${var.environment}"
  bucket_silver  = "gim-cs-slv-${var.environment}"
  bucket_gold    = "gim-cs-gld-${var.environment}"

  composer_name = "${var.region}-gim-composer-${var.environment}"
  dataplex_lake = "lake-${var.domain}-${var.environment}"

  service_account_dataproc = "sa-dataproc-processing-${var.environment}"
  service_account_composer = "sa-composer-orchestration-${var.environment}"
}
