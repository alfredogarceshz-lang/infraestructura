locals {
  common_labels = merge(var.labels, {
    environment = var.environment
    managed_by  = "terraform"
    repository  = "terraform-gcp"
  })
}
