output "composer_name" {
  value = var.create ? google_composer_environment.main[0].name : null
}

output "composer_id" {
  value = var.create ? google_composer_environment.main[0].id : null
}

output "gke_cluster" {
  value = var.create ? google_composer_environment.main[0].config[0].gke_cluster : null
}
