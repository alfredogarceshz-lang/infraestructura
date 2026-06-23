variable "create" {
  type        = bool
  default     = false
  description = "Bandera para crear o no el ambiente Composer."
}

variable "project_id" {
  type        = string
  description = "ID del proyecto GCP donde se desplegará el ambiente."
}

variable "region" {
  type        = string
  description = "Región de GCP donde se desplegará el ambiente Composer."
}

variable "composer_name" {
  type        = string
  description = "Nombre del ambiente Cloud Composer."
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Etiquetas (labels) a aplicar al recurso."
}

# ---------------------------------------------------------------------------
# Composer 3 — Environment Size
# Reemplaza la combinación machine_type + node_count + disk_size_gb.
# Controla el tamaño del plano de control administrado (API server, etc.).
# ---------------------------------------------------------------------------
variable "environment_size" {
  type        = string
  default     = "ENVIRONMENT_SIZE_SMALL"
  description = "Tamaño del ambiente Composer 3. Valores válidos: ENVIRONMENT_SIZE_SMALL, ENVIRONMENT_SIZE_MEDIUM, ENVIRONMENT_SIZE_LARGE."
  validation {
    condition = contains([
      "ENVIRONMENT_SIZE_SMALL",
      "ENVIRONMENT_SIZE_MEDIUM",
      "ENVIRONMENT_SIZE_LARGE"
    ], var.environment_size)
    error_message = "environment_size debe ser ENVIRONMENT_SIZE_SMALL, ENVIRONMENT_SIZE_MEDIUM o ENVIRONMENT_SIZE_LARGE."
  }
}

# ---------------------------------------------------------------------------
# Composer 3 — Scheduler (workloads_config)
# Composer 3 expone cada componente de Airflow de forma individual.
# Los valores por defecto corresponden al preset SMALL de la calculadora GCP.
# ---------------------------------------------------------------------------
variable "scheduler_cpu" {
  type        = number
  default     = 0.5
  description = "CPUs asignados al Scheduler de Airflow (fraccionarios permitidos)."
}

variable "scheduler_memory_gb" {
  type        = number
  default     = 1.875
  description = "Memoria en GiB asignada al Scheduler de Airflow."
}

variable "scheduler_storage_gb" {
  type        = number
  default     = 1
  description = "Almacenamiento en GiB asignado al Scheduler de Airflow."
}

variable "scheduler_count" {
  type        = number
  default     = 1
  description = "Número de instancias del Scheduler de Airflow."
}

# ---------------------------------------------------------------------------
# Composer 3 — Worker (workloads_config)
# Los workers ejecutan las tareas de los DAGs. Se escalan automáticamente
# entre min_count y max_count según la carga del ambiente.
# Los valores por defecto corresponden al preset SMALL de la calculadora GCP.
# ---------------------------------------------------------------------------
variable "worker_cpu" {
  type        = number
  default     = 0.5
  description = "CPUs asignados a cada Worker de Airflow (fraccionarios permitidos)."
}

variable "worker_memory_gb" {
  type        = number
  default     = 1.875
  description = "Memoria en GiB asignada a cada Worker de Airflow."
}

variable "worker_storage_gb" {
  type        = number
  default     = 1
  description = "Almacenamiento en GiB asignado a cada Worker de Airflow."
}

variable "worker_min_count" {
  type        = number
  default     = 1
  description = "Número mínimo de Workers activos (escala automática)."
}

variable "worker_max_count" {
  type        = number
  default     = 2
  description = "Número máximo de Workers activos (escala automática)."
}

# ---------------------------------------------------------------------------
# Composer 3 — Web Server (workloads_config)
# Sirve la UI de Airflow. En dev no requiere más recursos que el preset SMALL.
# ---------------------------------------------------------------------------
variable "web_server_cpu" {
  type        = number
  default     = 0.5
  description = "CPUs asignados al Web Server de Airflow."
}

variable "web_server_memory_gb" {
  type        = number
  default     = 1.875
  description = "Memoria en GiB asignada al Web Server de Airflow."
}

variable "web_server_storage_gb" {
  type        = number
  default     = 1
  description = "Almacenamiento en GiB asignado al Web Server de Airflow."
}
