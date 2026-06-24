variable "project_id" {
  type = string
}

variable "location" {
  type = string
}

variable "datasets" {
  description = "Map of dataset IDs to description."
  type        = map(string)
}

variable "external_tables" {
  description = "Map de tablas externas de BigQuery. Llave = table_id."
  type = map(object({
    table_id          = string
    dataset_id        = string
    source_uris       = list(string)
    source_uri_prefix = string
    hive_partitioning_mode  = optional(string, "AUTO")
    require_partition_filter = optional(bool, true)
    schema = list(object({
      name = string
      type = string
      mode = string
    }))
  }))
  default = {}
}

variable "iceberg_tables" {
  description = "Map de tablas Apache Iceberg en BigQuery. Llave = table_id."
  type = map(object({
    table_id    = string
    dataset_id  = string
    source_uris = list(string)
    # Nota: el particionado real de Iceberg se define en el engine que escribe
    # la tabla (Spark/Flink/etc.) y queda en la metadata del iceberg table.
    partition_fields = optional(list(string), [])
    schema = list(object({
      name = string
      type = string
      mode = string
    }))
  }))
  default = {}
}


