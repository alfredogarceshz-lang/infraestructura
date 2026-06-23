output "composer_name" {
  value = var.create ? google_composer_environment.main[0].name : null
}

output "composer_id" {
  value = var.create ? google_composer_environment.main[0].id : null
}

# gke_cluster eliminado: Composer 3 (Managed Airflow) no expone un clúster GKE.
