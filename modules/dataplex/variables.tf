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
  description = "Ambiente para nomenclatura obligatoria del lake: gim-lake-{env}."
  type        = string
}

variable "labels" {
  description = "Labels aplicadas a lake, zones y assets."
  type        = map(string)
  default     = {}
}

variable "zones" {
  description = "Configuracion de zones por capa. Llaves permitidas: brz, slv, gld."
  type = map(object({
    type                       = optional(string, "RAW")
    discovery_enabled          = optional(bool, true)
    discovery_schedule         = optional(string, "0 * * * *")
    discovery_include_patterns = optional(list(string), [])
    discovery_exclude_patterns = optional(list(string), [])
    labels                     = optional(map(string), {})
  }))

  default = {
    brz = { type = "RAW" }
    slv = { type = "CURATED" }
    gld = { type = "CURATED" }
  }

  validation {
    condition = alltrue([
      for layer in keys(var.zones) : contains(["brz", "slv", "gld"], layer)
    ])
    error_message = "Las capas permitidas para zones son: brz, slv, gld."
  }

  validation {
    condition = alltrue([
      for z in values(var.zones) : contains(["RAW", "CURATED"], upper(z.type))
    ])
    error_message = "zones.<capa>.type debe ser RAW o CURATED."
  }
}

variable "assets" {
  description = "Assets Dataplex. La llave debe cumplir asset-{capa}-{recurso}."
  type = map(object({
    layer             = string
    resource_type     = string
    resource_name     = string
    discovery_enabled = optional(bool, true)
    labels            = optional(map(string), {})
  }))
  default = {
    # STORAGE
    asset-brz-storage-dev  = { layer = "brz", resource_type = "STORAGE", resource_name = "gim-cs-brz-dev" }
    asset-brz-storage-qa   = { layer = "brz", resource_type = "STORAGE", resource_name = "gim-cs-brz-qa" }
    asset-brz-storage-prod = { layer = "brz", resource_type = "STORAGE", resource_name = "gim-cs-brz-prod" }

    asset-slv-storage-dev  = { layer = "slv", resource_type = "STORAGE", resource_name = "gim-cs-slv-dev" }
    asset-slv-storage-qa   = { layer = "slv", resource_type = "STORAGE", resource_name = "gim-cs-slv-qa" }
    asset-slv-storage-prod = { layer = "slv", resource_type = "STORAGE", resource_name = "gim-cs-slv-prod" }

    # BIGQUERY
    asset-brz-bigquery-dev  = { layer = "brz", resource_type = "BIGQUERY", resource_name = "gim_dataset_brz_dev" }
    asset-brz-bigquery-qa   = { layer = "brz", resource_type = "BIGQUERY", resource_name = "gim_dataset_brz_qa" }
    asset-brz-bigquery-prod = { layer = "brz", resource_type = "BIGQUERY", resource_name = "gim_dataset_brz_prod" }

    asset-slv-bigquery-dev  = { layer = "slv", resource_type = "BIGQUERY", resource_name = "gim_dataset_slv_dev" }
    asset-slv-bigquery-qa   = { layer = "slv", resource_type = "BIGQUERY", resource_name = "gim_dataset_slv_qa" }
    asset-slv-bigquery-prod = { layer = "slv", resource_type = "BIGQUERY", resource_name = "gim_dataset_slv_prod" }

    asset-gld-bigquery-dev  = { layer = "gld", resource_type = "BIGQUERY", resource_name = "gim_dataset_gld_dev" }
    asset-gld-bigquery-qa   = { layer = "gld", resource_type = "BIGQUERY", resource_name = "gim_dataset_gld_qa" }
    asset-gld-bigquery-prod = { layer = "gld", resource_type = "BIGQUERY", resource_name = "gim_dataset_gld_prod" }
  }

  validation {
    condition = alltrue([
      for asset_name, a in var.assets : (
        length(regexall("^asset-(brz|slv|gld)-[a-z0-9-]+$", asset_name)) > 0
      )
    ])
    error_message = "La llave de cada asset debe seguir asset-{capa}-{recurso}."
  }

  validation {
    condition = alltrue([
      for _, a in var.assets : contains(["brz", "slv", "gld"], a.layer)
    ])
    error_message = "assets.<name>.layer debe ser brz, slv o gld."
  }

  validation {
    condition = alltrue([
      for _, a in var.assets : contains(["STORAGE", "BIGQUERY"], upper(a.resource_type))
    ])
    error_message = "assets.<name>.resource_type debe ser STORAGE o BIGQUERY."
  }

  validation {
    condition = alltrue([
      for _, a in var.assets : !(a.layer == "gld" && upper(a.resource_type) == "STORAGE")
    ])
    error_message = "La capa gld (gold) solo permite assets BIGQUERY; no se permite STORAGE."
  }

  validation {
    condition = alltrue([
      for _, a in var.assets : contains(keys(var.zones), a.layer)
    ])
    error_message = "Cada asset debe apuntar a una zone existente para su capa."
  }
}
