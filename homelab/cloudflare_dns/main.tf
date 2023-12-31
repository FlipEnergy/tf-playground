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
    minify {
      css  = "on"
      js   = "off"
      html = "off"
    }
  }
}
