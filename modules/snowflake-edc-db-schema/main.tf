
resource "snowflake_database" "edc" {
  name                        = var.edc_db
  data_retention_time_in_days = var.data_retention_days
  comment                     = "Managed by Terraform"

  lifecycle {
    prevent_destroy = true
  }
}

resource "snowflake_schema" "admin" {
  database            = snowflake_database.edc.name
  name                = var.admin_schema_name
  with_managed_access = var.managed_access
  comment             = "Managed by Terraform"
}

resource "snowflake_schema" "edc_region" {
  for_each = toset(var.edc_regions)

  database            = snowflake_database.edc.name
  name                = each.value
  with_managed_access = var.managed_access
  comment             = "Managed by Terraform"
}