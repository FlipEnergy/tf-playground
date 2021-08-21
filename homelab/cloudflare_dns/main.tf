resource "cloudflare_zone" "pleasenoddos_zone" {
  zone = "pleasenoddos.com"
}

resource "cloudflare_zone_settings_override" "pleasenoddos_settings" {
  zone_id = cloudflare_zone.pleasenoddos_zone.id
  settings {
    always_use_https = "on"
    websockets = "on"
    ssl = "strict"
    min_tls_version = "1.2"
    minify {
      css = "on"
      js = "off"
      html = "off"
    }
  }
}
