data "cloudflare_accounts" "my_account" {
  name = "Dennis Homelab"
}

locals {
  zone_settings = {
    always_use_https = "on"
    websockets       = "on"
    ssl              = "strict"
    min_tls_version  = "1.2"
  }
}

resource "cloudflare_zone" "zone" {
  account = {
    id = data.cloudflare_accounts.my_account.result[0].id
  }
  name = var.root_domain
}

resource "cloudflare_zone_setting" "zone_settings" {
  for_each   = local.zone_settings
  zone_id    = cloudflare_zone.zone.id
  setting_id = each.key
  value      = each.value
}

# A records by default; an entry may set `type` and `content` instead of `ip`
# (e.g. a CNAME to the Cloudflare tunnel). Changing `type` replaces the record
# (destroy, then create), which Cloudflare requires anyway since a CNAME can't
# coexist with an A record of the same name.
resource "cloudflare_dns_record" "a_records" {
  for_each = var.a_records
  name     = each.value.name
  proxied  = lookup(each.value, "proxied", true)
  type     = lookup(each.value, "type", "A")
  content  = lookup(each.value, "content", lookup(each.value, "ip", null))
  ttl      = 1
  zone_id  = cloudflare_zone.zone.id
}

resource "cloudflare_dns_record" "cname_records" {
  for_each = var.cname_records
  name     = each.value.name
  proxied  = true
  type     = "CNAME"
  content  = each.value.cname
  ttl      = 1
  zone_id  = cloudflare_zone.zone.id
}
