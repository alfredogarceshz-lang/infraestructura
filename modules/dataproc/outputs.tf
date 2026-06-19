output "cluster_name" {
  value = var.create ? google_dataproc_cluster.main[0].name : null
}

output "cluster_id" {
  value = var.create ? google_dataproc_cluster.main[0].id : null
}

output "dataproc_enabled" {
  value = var.create
}
