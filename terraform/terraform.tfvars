# ── Snowflake Connection ──────────────────────────────────────────
snowflake_organization_name = "TZJLTWP"
snowflake_account_name      = "DI07734"
snowflake_user              = "TERRAFORM_SVC"
snowflake_role              = "ACCOUNTADMIN"
snowflake_authenticator     = "SNOWFLAKE_JWT"

# ── EDC Database ──────────────────────────────────────────────────
edc_db = "DEV_EDC"

# ── Source Database ───────────────────────────────────────────────
source_db     = "DEV"

# ── Access Table ──────────────────────────────────────────────────
access_db     = "DEV"
access_schema = "EDC_INTERNAL"
access_table  = "ACCOUNT_ORGANISATION_ACCESS"

# ── Warehouse ─────────────────────────────────────────────────────
warehouse                   = "COMPUTE_WH"
target_lag_maximum_duration = "30 minutes"

# ── Account Filtering ─────────────────────────────────────────────
target_account = ["apac", "na"]


warehouse_name = "WH_EDC_DEV"

snowflake_private_key_path  = "../.ssh/snowflake_tf_snow_key.p8"