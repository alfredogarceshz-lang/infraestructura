output "lake_id" {
  value = var.create ? google_dataplex_lake.main[0].id : null
}

output "lake_name" {
  value = var.create ? google_dataplex_lake.main[0].name : null
}

output "dataplex_lake" {
  value = var.lake_name
}
