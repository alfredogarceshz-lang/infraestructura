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


