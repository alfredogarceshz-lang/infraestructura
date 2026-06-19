variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "bucket_names" {
  description = "Map with keys landing/bronze/silver/gold and bucket names."
  type        = map(string)
}

variable "labels" {
  type    = map(string)
  default = {}
}
