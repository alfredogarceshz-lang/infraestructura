resource "terraform_data" "pubsub_config" {
  count = var.create ? 1 : 0

  input = {
    project_id         = var.project_id
    topic_name         = var.topic_name
    subscription_name  = var.subscription_name
  }
}
