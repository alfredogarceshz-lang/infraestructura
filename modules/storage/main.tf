resource "google_storage_bucket" "lakehouse" {
  for_each = var.bucket_names

  project                     = var.project_id
  name                        = each.value
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = false
  labels                      = merge(var.labels, { layer = each.key })

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 90
    }

    action {
      type = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
}
