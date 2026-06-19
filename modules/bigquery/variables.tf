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

variable "example_table" {
  description = "Example table definition in bronze dataset."
  type = object({
    dataset_id = string
    table_id   = string
  })
}
