output "edc_db" {
  value = snowflake_database.edc.name
}

output "edc_region_schemas" {
  value = sort([for s in snowflake_schema.edc_region : "${s.database}.${s.name}"])
}

output "admin_schema" {
  value = "${snowflake_database.edc.name}.${var.admin_schema_name}"
}

output "admin_schema_name" {
  value = var.admin_schema_name
}