resource "google_composer_environment" "main" {
  count = var.create ? 1 : 0

  project    = var.project_id
  name       = var.composer_name
  region     = var.region
  labels     = var.labels

  config {
    software_config {
      image_version = "composer-2-stable"
    }

    node_config {
      zone = "${var.region}-a"
    }
  }
}
