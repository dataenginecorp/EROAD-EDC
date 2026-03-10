variable "database_name" {
  type        = string
  description = "The Snowflake database to share from."
}

variable "schemas" {
  type        = list(string)
  description = "List of schemas to create shares for."
}

variable "views" {
  type = list(object({
    schema = string
    view   = string
  }))
  default     = []
  description = "List of views to grant SELECT on, each associated with a schema."
}

variable "share_name_prefix" {
  type        = string
  default     = ""
  description = "Optional prefix for share names."
}

