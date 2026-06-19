output "bucket_urls" {
  value = { for k, v in google_storage_bucket.lakehouse : k => v.url }
}
