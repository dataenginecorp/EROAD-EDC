variable "name_prefix" {
  type    = string
  default = ""
}

variable "sql_tables_root" { type = string }
variable "edc_db"          { type = string }

# Use this instead of edc_regions
variable "region_cloud_rows" {
  type = list(object({
    schema_name = string  # e.g. EASTUS_AZURE (schema name in DEV_EDC)
    region_raw  = string  # e.g. eastus (value in aoa.REGION)
    cloud_raw   = string  # e.g. AZURE  (value in aoa.CLOUD)
  }))
}

variable "source_db"     { type = string }

variable "warehouse" { type = string }

variable "target_lag_maximum_duration" {
  type    = string
  default = "30 minutes"
}

variable "access_db"     { type = string }
variable "access_schema" { type = string }
variable "access_table"  { type = string }

variable "target_account" {
  description = "Account keys to filter deployable tables e.g. [\"apac\", \"na\"]"
  type        = list(string)
}
variable "default_account" {
  description = "Fallback account key for tables without a meta.json"
  type        = string
  default     = ""
}

variable "admin_schema" {
  type        = string
  description = "Admin schema name, passed from the edc module output."
}

variable "admin_dt_name" {
  type        = string
  description = "Name of the dynamic table in the admin schema."
  default     = "ADMIN_DT"
}
