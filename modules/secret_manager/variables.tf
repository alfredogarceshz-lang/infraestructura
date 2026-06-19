variable "project_id" {
  type = string
}

variable "secret_id" {
  type = string
}

variable "secret_value" {
  type      = string
  sensitive = true
}
