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


