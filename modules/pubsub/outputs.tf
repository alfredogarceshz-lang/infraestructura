output "topic_name" {
  value = var.create ? google_pubsub_topic.main[0].name : null
}

output "subscription_name" {
  value = var.create ? google_pubsub_subscription.main[0].name : null
}

output "pubsub_enabled" {
  value = var.create
}
