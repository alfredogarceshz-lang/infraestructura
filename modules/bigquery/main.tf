resource "google_bigquery_dataset" "datasets" {
  for_each = var.datasets

  project       = var.project_id
  dataset_id    = each.key
  location      = var.location
  description   = each.value
  friendly_name = each.key
}


