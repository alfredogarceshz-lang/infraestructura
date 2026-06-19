resource "terraform_data" "dataproc_config" {
  count = var.create ? 1 : 0

  input = {
    project_id  = var.project_id
    region      = var.region
    environment = var.environment
  }
}
