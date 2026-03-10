variable "edc_db" {
  type        = string
  description = "EDC DB to create/manage (DEV_EDC, TEST_EDC, PP_EDC, EDC)."
}

variable "data_retention_days" {
  description = "Number of days to retain data in the Snowflake database"
  type        = number
  default     = 7
}

variable "edc_regions" {
  type        = list(string)
  description = "Regional schemas to create in the EDC DB (NZ, AU, ...)."
}

variable "admin_schema_name" {
  type        = string
  description = "Admin schema name."
  default     = "ADMIN"
}

variable "managed_access" {
  type        = bool
  description = "Create schemas with managed access."
  default     = true
}