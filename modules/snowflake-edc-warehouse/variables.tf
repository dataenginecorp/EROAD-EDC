variable "warehouse_name" { type = string }

variable "warehouse_size" {
  type    = string
  default = "XSMALL"
}

variable "auto_suspend" {
  type    = number
  default = 20
}

variable "auto_resume" {
  type    = bool
  default = true
}

variable "initially_suspended" {
  type    = bool
  default = true
}

variable "max_cluster_count" {
  type    = number
  default = 1
}

variable "min_cluster_count" {
  type    = number
  default = 1
}

variable "scaling_policy" {
  type    = string
  default = "STANDARD"
}

variable "comment" {
  type    = string
  default = "Managed by Terraform"
}