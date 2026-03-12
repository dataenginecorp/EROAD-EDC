locals {
  prefix = trimspace(var.role_prefix) == "" ? "" : "${upper(trimspace(var.role_prefix))}_"


  roles = {
    read       = "${local.prefix}${var.database_name}_READ"
    read_write = "${local.prefix}${var.database_name}_READ_WRITE"
    admin      = "${local.prefix}${var.database_name}_ADMIN"
  }

  role_db_privileges = {
    read       = ["USAGE"]
    read_write = ["USAGE"]
    admin      = ["ALL PRIVILEGES"]
  }

  role_schema_privileges = {
    read       = ["USAGE"]
    read_write = ["USAGE"]
    admin      = ["ALL PRIVILEGES"]
  }

  role_object_privileges = {
    read = {
      "VIEWS"          = ["SELECT"]
      "DYNAMIC TABLES" = ["SELECT"]
    }
    read_write = {
      "VIEWS"          = ["SELECT"]
      "DYNAMIC TABLES" = ["SELECT", "OPERATE", "MONITOR"]
    }
    admin = {
      "TABLES"         = ["ALL PRIVILEGES"]
      "VIEWS"          = ["ALL PRIVILEGES"]
      "DYNAMIC TABLES" = ["ALL PRIVILEGES"]
    }
  }

  role_object_grants = merge([
    for role, objects in local.role_object_privileges : {
      for obj_type, privs in objects :
      "${role}_${replace(lower(obj_type), " ", "_")}" => {
        role        = role
        object_type = obj_type
        privileges  = privs
      }
    }
  ]...)

  # Explicitly quoted FQN to avoid provider quoting bug with underscores
  role_fqn = {
    for key, name in local.roles :
    key => "\"${var.database_name}\".\"${name}\""
  }
}

############################################
# DATABASE ROLES
############################################

resource "snowflake_database_role" "this" {
  for_each = local.roles

  database = var.database_name
  name     = each.value
  comment  = "Managed by Terraform"
}

############################################
# DATABASE-LEVEL GRANTS
############################################

resource "snowflake_grant_privileges_to_database_role" "db_level" {
  for_each = local.role_db_privileges

  database_role_name = local.role_fqn[each.key]
  privileges         = each.value
  on_database        = var.database_name
}

############################################
# SCHEMA-LEVEL GRANTS (all + future)
############################################

resource "snowflake_grant_privileges_to_database_role" "schema_all" {
  for_each = local.role_schema_privileges

  database_role_name = local.role_fqn[each.key]
  privileges         = each.value
  on_schema {
    all_schemas_in_database = var.database_name
  }
}

resource "snowflake_grant_privileges_to_database_role" "schema_future" {
  for_each = local.role_schema_privileges

  database_role_name = local.role_fqn[each.key]
  privileges         = each.value
  on_schema {
    future_schemas_in_database = var.database_name
  }
}

############################################
# OBJECT-LEVEL GRANTS (all + future)
############################################

resource "snowflake_grant_privileges_to_database_role" "objects_all" {
  for_each = local.role_object_grants

  database_role_name = local.role_fqn[each.value.role]
  privileges         = each.value.privileges
  on_schema_object {
    all {
      object_type_plural = each.value.object_type
      in_database        = var.database_name
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "objects_future" {
  for_each = local.role_object_grants

  database_role_name = local.role_fqn[each.value.role]
  privileges         = each.value.privileges
  on_schema_object {
    future {
      object_type_plural = each.value.object_type
      in_database        = var.database_name
    }
  }
}