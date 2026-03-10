provider "snowflake" {
  organization_name = var.snowflake_organization_name
  account_name      = var.snowflake_account_name

  user          = var.snowflake_user
  role          = var.snowflake_role
  authenticator = var.snowflake_authenticator

  private_key = file(var.snowflake_private_key_path)

  warehouse  = var.warehouse

  preview_features_enabled = [
    "snowflake_dynamic_table_resource",
    "snowflake_share_resource",
  ]
  
}