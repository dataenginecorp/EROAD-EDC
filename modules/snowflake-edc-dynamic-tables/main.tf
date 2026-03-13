locals {
  prefix = trimspace(var.name_prefix) == "" ? "" : "${upper(trimspace(var.name_prefix))}_"

# Read meta.json per folder, default to empty object if not found
  all_meta = {
    for folder in distinct([
      for f in fileset(var.sql_tables_root, "*/dynamic_table.sql") : split("/", f)[0]  
    ]) :
    folder => try(
      jsondecode(file("${var.sql_tables_root}/${folder}/meta.json")),
      {} 
    )
  }

  # If no meta.json, fall back to var.default_account
  eligible_keys = toset([
    for k, meta in local.all_meta :
    k if length(setintersection(
      toset(var.target_account),
      toset(try(tolist(lookup(meta, "account", var.default_account)), [lookup(meta, "account", var.default_account)]))
    )) > 0
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
    for x in flatten([
      for k, d in local.dt_defs : [
        for rc in var.region_cloud_rows : {
          key        = "${k}.${rc.schema_name}"
          table_key  = k
          schema     = rc.schema_name
          region_raw = rc.region_raw
          cloud_raw  = rc.cloud_raw
          sql_path   = d.sql_path
        }
      ]
    ]) : x.key => x
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