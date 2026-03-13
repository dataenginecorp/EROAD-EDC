output "dynamic_tables" {
  value = {
    for k, v in snowflake_dynamic_table.dt :
    k => "${v.database}.${v.schema}.${v.name}"
  }
}