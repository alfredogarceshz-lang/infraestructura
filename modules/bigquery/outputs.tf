output "dataset_ids" {
  value = keys(google_bigquery_dataset.datasets)
}

output "external_table_ids" {
  value = keys(google_bigquery_table.external_tables)
}

