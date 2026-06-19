output "project_id" {
  value = module.naming.project_id
}

output "buckets" {
  value = {
    landing = module.naming.bucket_landing
    bronze  = module.naming.bucket_bronze
    silver  = module.naming.bucket_silver
    gold    = module.naming.bucket_gold
  }
}

output "service_accounts" {
  value = module.iam.service_account_emails
}

output "datasets" {
  value = module.bigquery.dataset_ids
}

output "secret_name" {
  value = module.secret_manager.secret_name
}
