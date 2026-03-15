locals {
  prefix = trimspace(var.name_prefix) == "" ? "" : "${upper(trimspace(var.name_prefix))}_"

  all_meta = jsondecode(file("${var.sql_tables_root}/tables.json"))

  eligible_keys = toset([
    for table, accounts in local.all_meta :
    table if length(setintersection(toset(accounts), toset(var.target_account))) > 0
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
    for pair in setproduct(keys(local.view_defs), var.region_schemas) :
    "${pair[0]}.${pair[1]}" => {
      table_key   = pair[0]
      schema_name = pair[1]
      sql_path    = local.view_defs[pair[0]].sql_path
    }
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
    admin_schema = var.admin_schema
  })
}
