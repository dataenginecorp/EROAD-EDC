locals {
  prefix = trimspace(var.name_prefix) == "" ? "" : "${upper(trimspace(var.name_prefix))}_"

# Read meta.json per folder, default to empty object if not found
  all_meta = {
    for folder in distinct([
      for f in fileset(var.sql_tables_root, "*/secure_view.sql") : split("/", f)[0] 
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

  # Filter secure view SQL files to eligible keys only
  view_defs = {
    for rel in fileset(var.sql_tables_root, "*/secure_view.sql") :
    split("/", rel)[0] => {
      table_key = split("/", rel)[0]
      sql_path  = "${var.sql_tables_root}/${rel}"
    }
    if contains(local.eligible_keys, split("/", rel)[0])
  }

dt_name_resolved = {
  for k, _ in local.view_defs :
  k => can(var.dt_module_output["${k}.${var.region_schemas[0]}"]) ? split(".", var.dt_module_output["${k}.${var.region_schemas[0]}"])[2] : "${local.prefix}DT_${upper(k)}"
}

  # View name per table key: <PREFIX>SVW_<KEY>
  view_name_resolved = {
    for k, _ in local.view_defs :
    k => "${local.prefix}${upper(k)}"
  }

  # Cartesian product: table_key x region_schemas
  view_instances = {
    for x in flatten([
      for k, d in local.view_defs : [
        for s in var.region_schemas : {
          key         = "${k}.${s}"
          table_key   = k
          schema_name = s
          sql_path    = d.sql_path
        }
      ]
    ]) : x.key => x
  }
}

resource "snowflake_view" "secure_view" {
  for_each = local.view_instances

  name     = local.view_name_resolved[each.value.table_key]
  database = var.edc_db
  schema   = each.value.schema_name

  is_secure = true

  statement = templatefile(each.value.sql_path, {
    edc_db        = var.edc_db
    region_schema = each.value.schema_name
    dynamic_table = local.dt_name_resolved[each.value.table_key]

    access_db     = var.access_db
    access_schema = var.access_schema
    access_table  = var.access_table
  })
}