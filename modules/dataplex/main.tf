locals {
  lake_name      = "gim-lake-${var.environment}"
  enabled_zones  = var.create ? var.zones : {}
  enabled_assets = var.create ? var.assets : {}
}

resource "google_dataplex_lake" "main" {
  count = var.create ? 1 : 0

  project      = var.project_id
  location     = var.region
  name         = local.lake_name
  display_name = local.lake_name
  description  = "Enterprise Dataplex Lake managed by Terraform"
  labels       = var.labels
}

resource "google_dataplex_zone" "zones" {
  for_each = local.enabled_zones

  project      = var.project_id
  location     = var.region
  lake         = google_dataplex_lake.main[0].name
  name         = "${each.key}-zone"
  display_name = "${each.key}-zone"
  type         = upper(each.value.type)
  labels       = merge(var.labels, each.value.labels)

  discovery_spec {
    enabled          = each.value.discovery_enabled
    include_patterns = each.value.discovery_include_patterns
    exclude_patterns = each.value.discovery_exclude_patterns
    schedule         = each.value.discovery_schedule
  }
}

resource "google_dataplex_asset" "assets" {
  for_each = local.enabled_assets

  project      = var.project_id
  location     = var.region
  lake         = google_dataplex_lake.main[0].name
  zone         = google_dataplex_zone.zones[each.value.layer].name
  name         = each.key
  display_name = each.key
  labels       = merge(var.labels, each.value.labels)

  resource_spec {
    type = upper(each.value.resource_type) == "STORAGE" ? "STORAGE_BUCKET" : "BIGQUERY_DATASET"
    name = upper(each.value.resource_type) == "STORAGE"
      ? "projects/${var.project_id}/buckets/${each.value.resource_name}"
      : "projects/${var.project_id}/datasets/${each.value.resource_name}"
  }

  discovery_spec {
    enabled = each.value.discovery_enabled
  }
}
