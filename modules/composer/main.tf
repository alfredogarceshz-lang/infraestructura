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

    environment_size = var.environment_size

    node_config {
      machine_type   = var.machine_type
      disk_size_gb   = var.disk_size_gb
      zone           = "${var.region}-a"
    }
  }
}
