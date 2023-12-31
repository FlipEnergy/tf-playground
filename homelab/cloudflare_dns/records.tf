# just create the entries, DDNS takes over updating so we ignore_changes on the ip
resource "cloudflare_record" "a_records" {
  for_each = var.a_records
  name     = each.value.name
  proxied  = lookup(each.value, "proxied", true)
  type     = "A"
  value    = each.value.ip
  zone_id  = cloudflare_zone.zone.id
}

resource "cloudflare_record" "cname_records" {
  for_each = var.cname_records
  name     = each.value.name
  proxied  = true
  type     = "CNAME"
  value    = each.value.cname
  zone_id  = cloudflare_zone.zone.id
}
