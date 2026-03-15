# output "query_results" {
#   value = snowflake_execute.region_cloud.query_results
# }

output "region_cloud_rows" {
  value = local.region_cloud_rows
}

output "schema_names" {
  value = local.schema_names
}