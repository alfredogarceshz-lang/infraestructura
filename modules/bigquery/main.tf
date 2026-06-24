resource "google_bigquery_dataset" "datasets" {
  for_each = var.datasets

  project       = var.project_id
  dataset_id    = each.key
  location      = var.location
  description   = each.value
  friendly_name = each.key
}

resource "google_bigquery_table" "external_tables" {
  for_each = var.external_tables

  project    = var.project_id
  dataset_id = each.value.dataset_id
  table_id   = each.value.table_id

  deletion_protection = false
  schema              = jsonencode(each.value.schema)

  external_data_configuration {
    source_format = "PARQUET"
    source_uris   = each.value.source_uris
    autodetect    = false

    hive_partitioning_options {
      mode                   = each.value.hive_partitioning_mode
      source_uri_prefix      = each.value.source_uri_prefix
      require_partition_filter = each.value.require_partition_filter
    }
  }
}

resource "google_bigquery_table" "iceberg_tables" {
  for_each = var.iceberg_tables

  project    = var.project_id
  dataset_id = each.value.dataset_id
  table_id   = each.value.table_id

  deletion_protection = false
  schema              = jsonencode(each.value.schema)

  external_data_configuration {
    source_format = "ICEBERG"
    source_uris   = each.value.source_uris
    autodetect    = false
  }
}


