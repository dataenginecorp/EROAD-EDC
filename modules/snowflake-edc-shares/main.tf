locals {
  prefix = trimspace(var.share_name_prefix) == "" ? "" : upper(trimspace(var.share_name_prefix))

  schemas_map = { for s in var.schemas : upper(s) => upper(s) }

  share_name_by_schema = {
    for k, s in local.schemas_map :
    k => join("_", compact([
      local.prefix,
      var.database_name,
      s
    ]))
  }

  schema_fqn_by_schema = {
    for k, s in local.schemas_map :
    k => "${var.database_name}.${s}"
  }

  views_map = {
    for v in var.views :
    "${upper(v.schema)}.${upper(v.view)}" => {
      schema = upper(v.schema)
      view   = upper(v.view)
    }
  }
}

resource "snowflake_share" "share" {
  for_each = local.schemas_map

  name    = local.share_name_by_schema[each.key]
  comment = "Share for ${var.database_name}.${each.value}"
}

resource "snowflake_grant_privileges_to_share" "db_usage" {
  for_each = local.schemas_map

  to_share    = snowflake_share.share[each.key].name
  privileges  = ["USAGE"]
  on_database = var.database_name
}
resource "snowflake_grant_privileges_to_share" "schema_usage" {
  for_each = local.schemas_map

  to_share   = snowflake_share.share[each.key].name
  privileges = ["USAGE"]
  on_schema  = local.schema_fqn_by_schema[each.key]

  depends_on = [snowflake_grant_privileges_to_share.db_usage]
}

resource "snowflake_grant_privileges_to_share" "view_select" {
  for_each = local.views_map

  to_share   = snowflake_share.share[each.value.schema].name
  privileges = ["SELECT"]
  on_view    = "${var.database_name}.${each.value.schema}.${each.value.view}"

  depends_on = [snowflake_grant_privileges_to_share.schema_usage]
}
