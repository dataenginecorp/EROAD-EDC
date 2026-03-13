resource "snowflake_listing" "listing" {
  for_each = var.shares_map

  name  = each.value.listing_name
  share = each.value.share_fqn

  manifest {
    from_string = <<-EOT
title: ${each.value.title}
subtitle: ${each.value.subtitle}
description: ${each.value.description}
listing_terms:
  type: OFFLINE
EOT
  }
  

  publish = false
  comment = var.comment_prefix != "" ? "${var.comment_prefix} - ${each.key}" : null
}