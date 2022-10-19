locals {
  my_public_ip = chomp(data.http.my_public_ip.response_body)
}

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
      ip      = local.my_public_ip
      proxied = true
    },
    "Flatnotes" : {
      name    = "notes"
      ip      = local.my_public_ip
      proxied = true
    },
    "Jellyfin" : {
      name    = "jelly"
      ip      = local.my_public_ip
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
      ip      = local.my_public_ip
      proxied = true
    },
    "Libreddit" : {
      name    = "reddit"
      ip      = var.oracle_arm_1_public_ip
      proxied = true
    },
    "Owncast" : {
      name    = "stream"
      ip      = local.my_public_ip
      proxied = true
    },
    "Nextcloud" : {
      name    = "cloud"
      ip      = local.my_public_ip
      proxied = true
    },
    "Wireguard" : {
      name    = "wg"
      ip      = local.my_public_ip
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
