resource "cloudflare_record" "star_a_record" {
  name    = "*"
  proxied = false
  type    = "A"
  value   = var.my_public_ip
  zone_id = cloudflare_zone.pleasenoddos_zone.id
}

resource "cloudflare_record" "a_records" {
  for_each = {
    "${cloudflare_zone.pleasenoddos_zone.zone}" = var.my_public_ip
    "www"                                       = var.my_public_ip
    "bitwarden"                                 = var.my_public_ip
    "focal"                                     = var.my_public_ip
    "freshrss"                                  = var.my_public_ip
    "gonic"                                     = var.my_public_ip
    "haste"                                     = var.my_public_ip
    "kube"                                      = var.my_public_ip
    "sharry"                                    = var.my_public_ip
    "stream"                                    = var.my_public_ip
    "whoogle"                                   = var.my_public_ip
    "wiki"                                      = var.my_public_ip
    "xyzzy"                                     = var.my_public_ip
  }
  name    = each.key
  proxied = true
  type    = "A"
  value   = each.value
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


resource "cloudflare_record" "txt_records" {
  for_each = {
    "acme1" : {
      name    = "_acme-challenge"
      content = "cGG856uboRxSYnid8SE54ApLU4mSieJZMJdwfz_3zQQ"
    },
    "acme2" : {
      name    = "_acme-challenge"
      content = "9JD8BDp3Va6JcQW2-0k9RHlgAKfLnuWQlz3QTvWXHms"
    }
  }
  name    = each.value.name
  type    = "TXT"
  value   = each.value.content
  zone_id = cloudflare_zone.pleasenoddos_zone.id
}
