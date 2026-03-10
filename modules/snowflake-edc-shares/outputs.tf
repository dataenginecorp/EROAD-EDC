output "share_names" {
  description = "Map of schema key to share name."
  value       = { for k, v in snowflake_share.share : k => v.name }
}

output "share_ids" {
  description = "Map of schema key to share ID."
  value       = { for k, v in snowflake_share.share : k => v.id }
}

output "granted_views" {
  description = "List of fully qualified view names granted SELECT on."
  value       = [for k, v in local.views_map : "${var.database_name}.${v.schema}.${v.view}"]
}

output "granted_schemas" {
  description = "List of fully qualified schema names granted USAGE on."
  value       = [for k, v in local.schema_fqn_by_schema : v]
}