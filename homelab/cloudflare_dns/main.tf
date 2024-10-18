data "cloudflare_accounts" "my_account" {
  name = "Dennis Homelab"
}

resource "cloudflare_zone" "zone" {
  account_id = data.cloudflare_accounts.my_account.accounts[0].id
  zone       = var.root_domain
}

resource "cloudflare_zone_settings_override" "zone_settings" {
  zone_id = cloudflare_zone.zone.id
  settings {
    always_use_https = "on"
    websockets       = "on"
    ssl              = "strict"
    min_tls_version  = "1.2"
  }
  lifecycle {
    ignore_changes = [
      initial_settings
    ]
  }
}

resource "cloudflare_record" "a_records" {
  for_each = var.a_records
  name     = each.value.name
  proxied  = lookup(each.value, "proxied", true)
  type     = "A"
  content  = each.value.ip
  zone_id  = cloudflare_zone.zone.id
}

resource "cloudflare_record" "cname_records" {
  for_each = var.cname_records
  name     = each.value.name
  proxied  = true
  type     = "CNAME"
  content  = each.value.cname
  zone_id  = cloudflare_zone.zone.id
}
