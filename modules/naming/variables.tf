variable "environment" {
  description = "Environment code: dev, qa, prod."
  type        = string
  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "environment must be one of: dev, qa, prod."
  }
}

variable "region" {
  description = "Primary GCP region."
  type        = string
}

variable "domain" {
  description = "Business domain for selected resources."
  type        = string
  default     = "enterprise"
}

variable "project_prefix" {
  description = "Project prefix following corporate naming."
  type        = string
  default     = "gim-data"
}
