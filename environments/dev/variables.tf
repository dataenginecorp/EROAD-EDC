variable "snowflake_organization_name" { type = string }
variable "snowflake_account_name" { type = string }
variable "snowflake_user" { type = string }
variable "snowflake_role" { type = string }
variable "snowflake_authenticator" { type = string }

variable "snowflake_private_key_path" { type = string } # relative to env/dev

variable "edc_db" { type = string }

variable "source_db" { type = string }

variable "warehouse" { type = string }
variable "target_lag_maximum_duration" { type = string }

variable "access_db" { type = string }
variable "access_schema" { type = string }
variable "access_table" { type = string }

variable "target_account" {
  description = "Account keys to filter deployable tables e.g. [\"apac\", \"na\"]"
  type        = list(string)
}

variable "default_account" {
  description = "Fallback account key for tables without a meta.json"
  type        = string
  default     = ""
}