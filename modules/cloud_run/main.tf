resource "terraform_data" "cloud_run_config" {
  count = var.create ? 1 : 0

  input = {
    project_id   = var.project_id
    region       = var.region
    service_name = var.service_name
  }
}
