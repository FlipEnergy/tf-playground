resource "cloudflare_record" "a_records" {
  for_each = {
    "root" : {
      name    = "${cloudflare_zone.pleasenoddos_zone.zone}"
      ip      = var.oracle_arm_1_public_ip
      proxied = true
    },
    "www" : {
      name    = "www"
      ip      = var.oracle_arm_1_public_ip
      proxied = true
    },
    "Bitwarden" : {
      name    = "bitwarden"
      ip      = chomp(data.http.my_public_ip.body)
      proxied = true
    },
    "Jellyfin" : {
      name    = "jelly"
      ip      = chomp(data.http.my_public_ip.body)
      proxied = true
    },
    "Hastebin" : {
      name    = "haste"
      ip      = var.oracle_arm_1_public_ip
      proxied = true
    },
    "Influxdb 2" : {
      name    = "influx"
      ip      = var.oracle_arm_1_public_ip
      proxied = true
    },
    "Kube Ops View" : {
      name    = "kube"
      ip      = chomp(data.http.my_public_ip.body)
      proxied = true
    },
    "Owncast" : {
      name    = "stream"
      ip      = chomp(data.http.my_public_ip.body)
      proxied = true
    },
    "Nextcloud" : {
      name    = "cloud"
      ip      = chomp(data.http.my_public_ip.body)
      proxied = true
    },
    "Wiki JS" : {
      name    = "wiki"
      ip      = chomp(data.http.my_public_ip.body)
      proxied = true
    },
    "Wireguard" : {
      name    = "wg"
      ip      = chomp(data.http.my_public_ip.body)
      proxied = false
    }
  }
  name    = each.value.name
  proxied = each.value.proxied
  type    = "A"
  value   = each.value.ip
  zone_id = cloudflare_zone.pleasenoddos_zone.id
}

resource "cloudflare_record" "cname_records" {
  for_each = {
    "status" = "statuspage.freshping.io"
  }
  name    = each.key
  proxied = true
  type    = "CNAME"
  value   = each.value
  zone_id = cloudflare_zone.pleasenoddos_zone.id
}
