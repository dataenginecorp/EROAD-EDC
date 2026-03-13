resource "snowflake_warehouse" "warehouse" {
  name                = var.warehouse_name
  warehouse_size      = var.warehouse_size

  auto_suspend        = var.auto_suspend
  auto_resume         = var.auto_resume
  initially_suspended = var.initially_suspended

  min_cluster_count   = var.min_cluster_count
  max_cluster_count   = var.max_cluster_count
  scaling_policy      = var.scaling_policy

  comment             = var.comment
}