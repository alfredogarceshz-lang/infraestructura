variable "create" {
  type    = bool
  default = false
}

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "composer_name" {
  type = string
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "machine_type" {
  type        = string
  default     = "n1-standard-4"
  description = "Machine type para los nodos. Ej: n1-standard-1, n1-standard-4, n1-standard-8"
}

variable "node_count" {
  type        = number
  default     = 3
  description = "Cantidad de nodos. Mínimo 3 para producción, puede ser menor en dev."
}

variable "disk_size_gb" {
  type        = number
  default     = 100
  description = "Tamaño de disco en GB para los nodos."
}

variable "environment_size" {
  type        = string
  default     = "MEDIUM"
  description = "Tamaño del ambiente: SMALL, MEDIUM, LARGE"
  validation {
    condition     = contains(["SMALL", "MEDIUM", "LARGE"], var.environment_size)
    error_message = "environment_size debe ser SMALL, MEDIUM o LARGE."
  }
}
