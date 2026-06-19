variable "project_id" {
  type = string
}

variable "service_accounts" {
  description = "Service account IDs (without domain)."
  type        = list(string)
}

variable "project_roles" {
  description = "Map of service account ID to project roles."
  type        = map(list(string))
  default     = {}
}
