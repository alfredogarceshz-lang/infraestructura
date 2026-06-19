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
