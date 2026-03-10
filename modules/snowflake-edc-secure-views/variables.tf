variable "name_prefix" {
  type    = string
  default = ""
}

variable "sql_tables_root" { type = string }
variable "edc_db"          { type = string }

# List of schemas to deploy into (e.g. ["NZ", "AU", "SG"] or ["EASTUS_AZURE", ...])
variable "region_schemas" {
  type = list(string)
}

variable "dt_module_output" {
  type        = map(string)
  description = "dynamic_tables output from the snowflake-edc-dynamic-tables module. Map of table_key => fully qualified DT name (db.schema.name)."
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