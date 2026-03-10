# snowflake-database-roles

A Terraform module that provisions a standard set of **database-scoped roles** for a Snowflake database, following a least-privilege, tiered access model.

---

## Overview

The module creates three database roles — `READ`, `READ_WRITE`, and `ADMIN` — and wires up all required privilege grants at the database, schema, and object levels, covering both existing and future objects.

An optional prefix can be supplied to namespace roles across multiple environments or teams (e.g. `PROD_MYDB_READ`).

---

## Requirements

| Tool | Version |
|---|---|
| Terraform | >= 1.3 |
| Snowflake provider (`snowflakedb/snowflake`) | >= 1.0.0 |

---

## Role Privilege Matrix

| Privilege | READ | READ_WRITE | ADMIN |
|---|---|---|---|
| **Database** | `USAGE` | `USAGE` | `ALL PRIVILEGES` |
| **Schemas (all + future)** | `USAGE` | `USAGE` | `ALL PRIVILEGES` |
| **Views** | `SELECT` | `SELECT` | `ALL PRIVILEGES` |
| **Dynamic Tables** | `SELECT` | `SELECT`, `OPERATE`, `MONITOR` | `ALL PRIVILEGES` |

---

## Usage

```hcl
module "mydb_roles" {
  source = "./modules/snowflake-database-roles"

  database_name = "MYDB"
  role_prefix   = "PROD"  # optional; results in PROD_MYDB_READ, etc.
}
```

Grant a Snowflake account role access to one of the database roles:

```hcl
resource "snowflake_grant_database_role" "analyst_read" {
  database_role_name = "\"MYDB\".\"${module.mydb_roles.read_role}\""
  parent_role_name   = "ANALYST"
}
```

---

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `database_name` | `string` | — | Name of the Snowflake database to manage roles for. |
| `role_prefix` | `string` | `""` | Optional prefix applied to all role names, uppercased automatically. A trailing `_` separator is added automatically when a non-empty prefix is provided. |

---

## Outputs

| Name | Description |
|---|---|
| `read_role` | Name of the read-only database role. |
| `read_write_role` | Name of the read/write database role. |
| `admin_role` | Name of the admin database role. |

---

## Role Naming Convention

Roles follow the pattern `[PREFIX_]<DATABASE>_<TIER>`, where `TIER` is one of `READ`, `READ_WRITE`, or `ADMIN`. The prefix is uppercased automatically.

| `role_prefix` | `database_name` | Resulting role names |
|---|---|---|
| *(empty)* | `MYDB` | `MYDB_READ`, `MYDB_READ_WRITE`, `MYDB_ADMIN` |
| `prod` | `MYDB` | `PROD_MYDB_READ`, `PROD_MYDB_READ_WRITE`, `PROD_MYDB_ADMIN` |
