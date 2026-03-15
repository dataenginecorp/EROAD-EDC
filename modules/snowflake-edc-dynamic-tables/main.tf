locals {
  prefix = trimspace(var.name_prefix) == "" ? "" : "${upper(trimspace(var.name_prefix))}_"

  all_meta = jsondecode(file("${var.sql_tables_root}/tables.json"))

  eligible_keys = toset([
    for table, accounts in local.all_meta :
    table if length(setintersection(toset(accounts), toset(var.target_account))) > 0
  ])
  
  # Filter dynamic table SQL files to eligible keys only
  dt_defs = {
    for rel in fileset(var.sql_tables_root, "*/dynamic_table.sql") :
    split("/", rel)[0] => {
      table_key = split("/", rel)[0]
      sql_path  = "${var.sql_tables_root}/${rel}"
    }
    if contains(local.eligible_keys, split("/", rel)[0])
  }

  # DT name per table key: <PREFIX>_<KEY>
  dt_name_by_table_key = {
    for k, _ in local.dt_defs :
    k => "${local.prefix}${upper(k)}"
  }

  # Cartesian product: table_key x region_cloud_rows
  dt_instances = {
    for pair in setproduct(keys(local.dt_defs), var.region_cloud_rows) :
    "${pair[0]}.${pair[1].schema_name}" => {
      table_key  = pair[0]
      schema     = pair[1].schema_name
      region_raw = pair[1].region_raw
      cloud_raw  = pair[1].cloud_raw
      sql_path   = local.dt_defs[pair[0]].sql_path
    }
  }
}

resource "snowflake_dynamic_table" "dt" {
  for_each = local.dt_instances

  name     = local.dt_name_by_table_key[each.value.table_key]
  database = var.edc_db
  schema   = each.value.schema

  target_lag {
    maximum_duration = var.target_lag_maximum_duration
  }

  warehouse = var.warehouse

  query = templatefile(each.value.sql_path, {
    source_db     = var.source_db
    base_table    = upper(each.value.table_key)

    access_db     = var.access_db
    access_schema = var.access_schema
    access_table  = var.access_table

    region        = each.value.region_raw
    cloud         = each.value.cloud_raw

    region_schema = each.value.schema
    edc_db        = var.edc_db
    dynamic_table = local.dt_name_by_table_key[each.value.table_key]
  })

  comment = "Managed by Terraform"
}

resource "snowflake_dynamic_table" "admin_dt" {
  name     = var.access_table
  database = var.edc_db


  schema   = var.admin_schema

  target_lag {
    maximum_duration = var.target_lag_maximum_duration
  }

  warehouse = var.warehouse

  query = "SELECT * FROM ${var.access_db}.${var.access_schema}.${var.access_table}"

  comment = "Managed by Terraform"
}