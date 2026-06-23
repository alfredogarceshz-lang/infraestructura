output "dataset_ids" {
  value = keys(google_bigquery_dataset.datasets)
}

