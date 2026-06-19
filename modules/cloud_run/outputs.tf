output "service_name" {
  value = var.create ? google_cloud_run_service.main[0].name : null
}

output "service_url" {
  value = var.create ? google_cloud_run_service.main[0].status[0].url : null
}

output "cloud_run_enabled" {
  value = var.create
}
