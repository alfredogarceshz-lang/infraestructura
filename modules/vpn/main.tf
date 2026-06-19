resource "terraform_data" "vpn_config" {
  count = var.create ? 1 : 0

  input = {
    project_id   = var.project_id
    region       = var.region
    network_name = var.network_name
  }
}
