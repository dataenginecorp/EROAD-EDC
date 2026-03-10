variable "access_db"     { type = string }
variable "access_schema" { type = string }
variable "access_table"  { type = string }

variable "region_column" {
  type    = string
  default = "REGION"
}

variable "cloud_column" {
  type    = string
  default = "CLOUD"
}

# Optional filter (e.g. "IS_ACTIVE = TRUE")
variable "access_where_sql" {
  type    = string
  default = "1=1"
}