resource "google_cloud_run_service" "main" {
  count = var.create ? 1 : 0

  project = var.project_id
  name    = var.service_name
  region  = var.region

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
