output "service_account_emails" {
  value = { for k, v in google_service_account.sa : k => v.email }
}

output "composer_service_account_email" {
  value = try(
    one([
      for k, v in google_service_account.sa : v.email
      if startswith(k, "sa-composer-ace-")
    ]),
    null
  )
}
