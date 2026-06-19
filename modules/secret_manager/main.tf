resource "google_secret_manager_secret" "this" {
  project   = var.project_id
  secret_id = var.secret_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "v1" {
  secret      = google_secret_manager_secret.this.id
  secret_data = var.secret_value
}
