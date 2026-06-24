output "lake_id" {
  value = var.create ? google_dataplex_lake.main[0].id : null
}

output "lake_name" {
  value = var.create ? google_dataplex_lake.main[0].name : null
}

output "dataplex_lake" {
  value = var.create ? google_dataplex_lake.main[0].name : null
}

output "lake" {
  value = var.create ? {
    id           = google_dataplex_lake.main[0].id
    name         = google_dataplex_lake.main[0].name
    display_name = google_dataplex_lake.main[0].display_name
    location     = google_dataplex_lake.main[0].location
    uid          = google_dataplex_lake.main[0].uid
  } : null
}

output "zones" {
  value = {
    for k, v in google_dataplex_zone.zones : k => {
      id           = v.id
      name         = v.name
      display_name = v.display_name
      type         = v.type
      location     = v.location
      lake         = v.lake
      uid          = v.uid
    }
  }
}

output "assets" {
  value = {
    for k, v in google_dataplex_asset.assets : k => {
      id           = v.id
      name         = v.name
      display_name = v.display_name
      zone         = v.zone
      lake         = v.lake
      location     = v.location
      uid          = v.uid
    }
  }
}

output "zone_ids" {
  value = { for k, v in google_dataplex_zone.zones : k => v.id }
}

output "asset_ids" {
  value = { for k, v in google_dataplex_asset.assets : k => v.id }
}
