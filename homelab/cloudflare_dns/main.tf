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

resource "cloudflare_dns_record" "a_records" {
  for_each = var.a_records
  name     = each.value.name
  proxied  = lookup(each.value, "proxied", true)
  type     = "A"
  content  = each.value.ip
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
