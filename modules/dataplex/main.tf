resource "terraform_data" "dataplex_config" {
  count = var.create ? 1 : 0

  input = {
    project_id = var.project_id
    region     = var.region
    lake_name  = var.lake_name
  }
}
