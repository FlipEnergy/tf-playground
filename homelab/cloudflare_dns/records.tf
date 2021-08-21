resource "cloudflare_record" "a_records" {
  for_each = {
    "${cloudflare_zone.pleasenoddos_zone.zone}": {
      proxied = true
      content = var.my_public_ip
    },
    "*": {
      proxied = false
      content = var.my_public_ip
    },
    "www": {
      proxied = true
      content = var.my_public_ip
    }
  }
  name = each.key
  proxied = each.value.proxied
  type = "A"
  value = each.value.content
  zone_id = cloudflare_zone.pleasenoddos_zone.id
}

resource "cloudflare_record" "cname_records" {
  for_each = {
    "status" = "statuspage.freshping.io"
  }
  name = each.key
  proxied = true
  type = "CNAME"
  value = each.value
  zone_id = cloudflare_zone.pleasenoddos_zone.id
}


resource "cloudflare_record" "txt_records" {
  for_each = {
    "acme1": {
      name = "_acme-challenge"
      content = "cGG856uboRxSYnid8SE54ApLU4mSieJZMJdwfz_3zQQ"
    },
    "acme2": {
      name = "_acme-challenge"
      content = "9JD8BDp3Va6JcQW2-0k9RHlgAKfLnuWQlz3QTvWXHms"
    }
  }
  name = each.value.name
  type = "TXT"
  value = each.value.content
  zone_id = cloudflare_zone.pleasenoddos_zone.id
}
