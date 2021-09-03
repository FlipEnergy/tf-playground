resource "cloudflare_record" "a_records" {
  for_each = {
    "root" : {
      name = "${cloudflare_zone.pleasenoddos_zone.zone}"
      ip   = var.oracle_arm_1_public_ip
    },
    "www" : {
      name = "www"
      ip   = var.my_public_ip
    },
    "Bitwarden" : {
      name = "bitwarden"
      ip   = var.my_public_ip
    },
    "Focalboard" : {
      name = "focal"
      ip   = var.my_public_ip
    }
    "Freshrss" : {
      name = "freshrss"
      ip   = var.my_public_ip
    },
    "Jellyfin" : {
      name = "jelly"
      ip   = var.my_public_ip
    },
    "Gonic" : {
      name = "gonic"
      ip   = var.my_public_ip
    },
    "Hastebin" : {
      name = "haste"
      ip   = var.oracle_arm_1_public_ip
    },
    "Influxdb 2" : {
      name = "influx"
      ip   = var.oracle_arm_1_public_ip
    },
    "Kube Ops View" : {
      name = "kube"
      ip   = var.my_public_ip
    },
    "Sharry" : {
      name = "sharry"
      ip   = var.my_public_ip
    },
    "Owncast" : {
      name = "stream"
      ip   = var.my_public_ip
    },
    "Nextcloud" : {
      name = "cloud"
      ip   = var.my_public_ip
    }
    "Whoogle" : {
      name = "whoogle"
      ip   = var.oracle_arm_1_public_ip
    },
    "Wiki JS" : {
      name = "wiki"
      ip   = var.my_public_ip
    },
    "Xyzzy" : {
      name = "xyzzy"
      ip   = var.my_public_ip
    }
  }
  name    = each.value.name
  proxied = true
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
