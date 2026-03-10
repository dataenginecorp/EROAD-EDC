output "read_role" {
  value = snowflake_database_role.this["read"].name
}

output "read_write_role" {
  value = snowflake_database_role.this["read_write"].name
}

output "admin_role" {
  value = snowflake_database_role.this["admin"].name
}