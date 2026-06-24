output "batch_name" {
  value = var.create ? google_dataproc_batch.main[0].name : null
}

output "batch_id" {
  value = var.create ? google_dataproc_batch.main[0].batch_id : null
}

output "batch_state" {
  value = var.create ? google_dataproc_batch.main[0].state : null
}

output "dataproc_enabled" {
  value = var.create
}

# Compatibilidad hacia atras con el output anterior.
output "cluster_name" {
  value = var.create ? google_dataproc_batch.main[0].batch_id : null
}
