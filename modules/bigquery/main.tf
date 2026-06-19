resource "google_bigquery_dataset" "datasets" {
  for_each = var.datasets

  project       = var.project_id
  dataset_id    = each.key
  location      = var.location
  description   = each.value
  friendly_name = each.key
}

# Example bronze table to validate end-to-end baseline wiring.
resource "google_bigquery_table" "example" {
  project    = var.project_id
  dataset_id = var.example_table.dataset_id
  table_id   = var.example_table.table_id

  schema = jsonencode([
    {
      name = "id"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "created_at"
      type = "TIMESTAMP"
      mode = "NULLABLE"
    }
  ])

  depends_on = [google_bigquery_dataset.datasets]
}
