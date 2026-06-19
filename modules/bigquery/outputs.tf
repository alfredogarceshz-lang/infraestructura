output "dataset_ids" {
  value = keys(google_bigquery_dataset.datasets)
}

output "example_table_id" {
  value = google_bigquery_table.example.id
}
