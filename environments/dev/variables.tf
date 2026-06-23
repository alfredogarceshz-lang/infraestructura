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

variable "external_tables" {
  description = "Tablas externas de BigQuery para capa bronze."
  type = map(object({
    dataset_id        = string
    source_uris       = list(string)
    source_uri_prefix = string
    schema = list(object({
      name = string
      type = string
      mode = string
    }))
  }))
  default = {}
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

variable "composer_environment_size" {
  type        = string
  default     = "ENVIRONMENT_SIZE_SMALL"
  description = "Tamaño del ambiente Composer 3: ENVIRONMENT_SIZE_SMALL, ENVIRONMENT_SIZE_MEDIUM, ENVIRONMENT_SIZE_LARGE."
}

variable "composer_scheduler_cpu" {
  type        = number
  default     = 0.5
  description = "CPUs asignados al Scheduler de Airflow."
}

variable "composer_scheduler_memory_gb" {
  type        = number
  default     = 1.875
  description = "Memoria en GiB asignada al Scheduler de Airflow."
}

variable "composer_scheduler_storage_gb" {
  type        = number
  default     = 1
  description = "Almacenamiento en GiB asignado al Scheduler de Airflow."
}

variable "composer_scheduler_count" {
  type        = number
  default     = 1
  description = "Número de instancias del Scheduler de Airflow."
}

variable "composer_worker_cpu" {
  type        = number
  default     = 0.5
  description = "CPUs asignados a cada Worker de Airflow."
}

variable "composer_worker_memory_gb" {
  type        = number
  default     = 1.875
  description = "Memoria en GiB asignada a cada Worker de Airflow."
}

variable "composer_worker_storage_gb" {
  type        = number
  default     = 1
  description = "Almacenamiento en GiB asignado a cada Worker de Airflow."
}

variable "composer_worker_min_count" {
  type        = number
  default     = 1
  description = "Número mínimo de Workers activos."
}

variable "composer_worker_max_count" {
  type        = number
  default     = 2
  description = "Número máximo de Workers activos."
}

variable "composer_web_server_cpu" {
  type        = number
  default     = 0.5
  description = "CPUs asignados al Web Server de Airflow."
}

variable "composer_web_server_memory_gb" {
  type        = number
  default     = 1.875
  description = "Memoria en GiB asignada al Web Server de Airflow."
}

variable "composer_web_server_storage_gb" {
  type        = number
  default     = 1
  description = "Almacenamiento en GiB asignado al Web Server de Airflow."
}
