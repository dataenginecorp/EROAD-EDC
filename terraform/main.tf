module "region_cloud" {
  source    = "../modules/snowflake-edc-region-cloud-query"

  access_db     = var.access_db
  access_schema = var.access_schema
  access_table  = var.access_table
}

module "edc_db_schema" {
  source = "../modules/snowflake-edc-db-schema"

  edc_db      = var.edc_db
  edc_regions = module.region_cloud.schema_names
  admin_schema_name   = "ADMIN"
  managed_access      = true

  depends_on = [module.region_cloud]
}

module "wh" {
  source    = "../modules/snowflake-edc-warehouse"

  warehouse_name = "WH_EDC_DEV"
  warehouse_size = "XSMALL"
  auto_suspend   = 60
  min_cluster_count = 1
  max_cluster_count = 1
  scaling_policy = "STANDARD"
}

module "edc_dynamic_tables" {
  source    = "../modules/snowflake-edc-dynamic-tables"
  target_account  = var.target_account
  edc_db          = var.edc_db
  sql_tables_root = "../sql/tables"

  region_cloud_rows = module.region_cloud.region_cloud_rows

  source_db     = var.source_db
  admin_schema = module.edc_db_schema.admin_schema_name

  warehouse = module.wh.warehouse_name

  access_db     = var.access_db
  access_schema = var.access_schema
  access_table  = var.access_table
  name_prefix = "DT"

  depends_on = [module.edc_db_schema,
                module.wh]        
}
module "edc_secure_views" {
  source    = "../modules/snowflake-edc-secure-views"

  target_account              = var.target_account
  edc_db          = var.edc_db
  sql_tables_root = "../sql/tables"

  dt_module_output = module.edc_dynamic_tables.dynamic_tables

  # drive from query output (schemas)
  region_schemas = module.region_cloud.schema_names

  access_db     = var.access_db
  access_schema = var.access_schema
  access_table  = var.access_table
  name_prefix = "SVW"

  depends_on = [module.edc_db_schema,
                module.edc_dynamic_tables]
}

module "edc_roles" {

  source = "../modules/snowflake-edc-database-roles"

  providers = {
    snowflake = snowflake
  }

  database_name = var.edc_db

  depends_on = [module.edc_db_schema]

}

module "edc_schema_shares" {
  source    = "../modules/snowflake-edc-shares"
  providers = { snowflake = snowflake }

  database_name     = var.edc_db
  schemas           = module.region_cloud.schema_names
  share_name_prefix = "SHARE"

   views = [
    for fqn in values(module.edc_secure_views.secure_view_fqns) : {
      schema = split(".", fqn)[1]
      view   = split(".", fqn)[2]
    }
  ]

  depends_on = [
    module.edc_db_schema,
    module.edc_secure_views,
  ]
}

module "edc_listings" {
  source    = "../modules/snowflake-edc-listings"

  comment_prefix = "EDC listing"

  shares_map = {
    for k, v in module.edc_schema_shares.share_names :
    k => {
      share_fqn    = module.edc_schema_shares.share_ids[k]
      listing_name = replace(v, "SHARE", "LISTING")
      title        = "EDC ${k} Private Listing"
      subtitle     = "EDC regional data for ${k}"
      description  = "Private listing for EDC ${k} "
    }
  }

  depends_on = [module.edc_schema_shares]
}