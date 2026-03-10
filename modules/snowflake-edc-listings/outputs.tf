output "listing_names" {
  value = { for k, v in snowflake_listing.listing : k => v.name }
}