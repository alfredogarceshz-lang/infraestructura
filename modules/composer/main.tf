# Structured expansion module: enable with create=true once networking and quotas are ready.
resource "terraform_data" "composer_config" {
  count = var.create ? 1 : 0

  input = {
    project_id    = var.project_id
    region        = var.region
    composer_name = var.composer_name
    labels        = var.labels
  }
}
