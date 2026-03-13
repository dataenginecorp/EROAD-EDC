output "dynamic_tables" {
  value = {
    for k, v in snowflake_dynamic_table.dt :
    k => "${v.database}.${v.schema}.${v.name}"
  }
}

output "admin_dynamic_table" {
  value = "${snowflake_dynamic_table.admin_dt.database}.${snowflake_dynamic_table.admin_dt.schema}.${snowflake_dynamic_table.admin_dt.name}"
}