output "secure_view_fqns" {
  value = {
    for k, v in snowflake_view.secure_view :
    k => "${v.database}.${v.schema}.${v.name}"
  }
}