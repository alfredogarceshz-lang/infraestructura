variable "environment" {
  type = string
}

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "domain" {
  type    = string
  default = "enterprise"
}

variable "labels" {
  type = map(string)
}

variable "datasets" {
  type = map(string)
}

variable "example_table_id" {
  type = string
}

variable "secret_value" {
  type      = string
  sensitive = true
}

variable "enable_composer" {
  type    = bool
  default = false
}

variable "enable_dataproc" {
  type    = bool
  default = false
}

variable "enable_dataplex" {
  type    = bool
  default = false
}

variable "enable_vpn" {
  type    = bool
  default = false
}

variable "enable_pubsub" {
  type    = bool
  default = false
}

variable "enable_cloud_run" {
  type    = bool
  default = false
}

variable "composer_machine_type" {
  type        = string
  default     = "n1-standard-4"
  description = "Machine type para Composer"
}

variable "composer_node_count" {
  type        = number
  default     = 3
  description = "Número de nodos para Composer"
}

variable "composer_disk_size_gb" {
  type        = number
  default     = 100
  description = "Tamaño de disco en GB para Composer"
}

variable "composer_environment_size" {
  type        = string
  default     = "MEDIUM"
  description = "Tamaño del ambiente Composer: SMALL, MEDIUM, LARGE"
}
