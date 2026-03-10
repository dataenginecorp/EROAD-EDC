resource "snowflake_execute" "region_cloud" {
  execute = "SELECT 1"
  revert  = "SELECT 1"

  query = <<SQL
SELECT DISTINCT
  ${var.region_column} AS REGION,
  ${var.cloud_column}  AS CLOUD
FROM "${var.access_db}"."${var.access_schema}"."${var.access_table}"
WHERE ${var.access_where_sql}
  AND ${var.region_column} IS NOT NULL
  AND ${var.cloud_column}  IS NOT NULL
ORDER BY 1,2
SQL
}

locals {
  # Build objects so other modules can use both:
  # - schema_name (EDC schema)
  # - region_raw / cloud_raw (for filtering)
  region_cloud_rows = [
    for r in snowflake_execute.region_cloud.query_results : {
      region_raw = r.REGION
      cloud_raw  = r.CLOUD

      # No regexreplace in Terraform; use replace() for common separators
      schema_name = upper(
        replace(
          replace(
            replace(
              replace("${r.CLOUD}_${r.REGION}", " ", "_"),
              "-", "_"
            ),
            ".", "_"
          ),
          "/",
          "_"
        )
      )
    }
  ]

  schema_names = sort([for x in local.region_cloud_rows : x.schema_name])
}