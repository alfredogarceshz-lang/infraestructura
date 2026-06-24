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

variable "environment" {
  type = string
}

variable "labels" {
  description = "Labels para el batch de Dataproc Serverless."
  type        = map(string)
  default     = {}
}

variable "batch_id" {
  description = "ID del Dataproc Serverless batch. Si null, usa dp-sls-{env}."
  type        = string
  default     = null
}

variable "service_account_email" {
  description = "Service account usada por Dataproc Serverless batch."
  type        = string
  default     = null
}

variable "subnetwork_uri" {
  description = "URI de subred opcional para el execution config."
  type        = string
  default     = null
}

variable "version" {
  description = "Versión runtime de Dataproc Serverless (ej. 2.2)."
  type        = string
  default     = "2.2"
}

variable "container_image" {
  description = "Imagen de contenedor opcional para runtime_config.container_image."
  type        = string
  default     = null
}

variable "properties" {
  description = "Propiedades Spark opcionales para runtime_config.properties."
  type        = map(string)
  default     = {}
}

variable "main_python_file_uri" {
  description = "URI del script principal de PySpark en GCS. Requerido si create=true."
  type        = string
  default     = null
}

variable "python_file_uris" {
  description = "Dependencias Python opcionales para el batch."
  type        = list(string)
  default     = []
}

variable "jar_file_uris" {
  description = "JARs opcionales para el batch."
  type        = list(string)
  default     = []
}

variable "args" {
  description = "Argumentos para el script PySpark."
  type        = list(string)
  default     = []
}

variable "ttl_seconds" {
  description = "TTL del batch en segundos."
  type        = number
  default     = 3600
}
