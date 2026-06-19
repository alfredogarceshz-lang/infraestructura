resource "google_pubsub_topic" "main" {
  count = var.create ? 1 : 0

  project = var.project_id
  name    = var.topic_name
}

resource "google_pubsub_subscription" "main" {
  count = var.create ? 1 : 0

  project = var.project_id
  name    = var.subscription_name
  topic   = google_pubsub_topic.main[0].name

  ack_deadline_seconds = 20
}
