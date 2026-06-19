resource "google_dataplex_lake" "main" {
  count = var.create ? 1 : 0

  location       = var.region
  name           = var.lake_name
  project        = var.project_id
  display_name   = var.lake_name
  description    = "Data Lake managed by Terraform"
}
