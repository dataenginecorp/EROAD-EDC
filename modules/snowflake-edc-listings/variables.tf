variable "shares_map" {
  type = map(object({
    share_fqn   = string
    listing_name = string
    title       = string
    subtitle    = string
    description = string
  }))
}

variable "comment_prefix" {
  type    = string
  default = ""
}