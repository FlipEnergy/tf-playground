locals {
  my_public_ip             = chomp(data.http.my_public_ip.response_body)
  pleasenoddos_root_domain = "pleasenoddos.com"
  pleasenoddos_a_records = {
    "root" : merge(local.via_tunnel, {
      name = local.pleasenoddos_root_domain
    }),
    "www" : merge(local.via_tunnel, {
      name = "www"
    }),
    "Bitwarden" : merge(local.via_tunnel, {
      name = "bitwarden"
    }),
    "Flatnotes" : merge(local.via_tunnel, {
      name = "notes"
    }),
    "HabitTrove" : merge(local.via_tunnel, {
      name = "habit"
    }),
    "PiKaraoke" : merge(local.via_tunnel, {
      name = "karaoke"
    }),
    "Kube Ops View" : merge(local.via_tunnel, {
      name = "kube"
    }),
    "Gonic" : merge(local.via_tunnel, {
      name = "gonic"
    }),
    "Nextcloud" : merge(local.via_tunnel, {
      name = "cloud"
    }),
    "Wireguard" : {
      name    = "wg"
      ip      = local.my_public_ip
      proxied = false
    }
  }
  pleasenoddos_cname_records = {}
  #  "status page" : {
  #    name  = "status"
  #    cname = "statuspage.freshping.io"
  #  }
  #}

  chunafishy_root_domain = "chunafishy.com"
  chunafishy_a_records = {
    "root" : {
      name = local.chunafishy_root_domain
      ip   = local.my_public_ip
    },
    "www" : {
      name = "www"
      ip   = local.my_public_ip
    },
  }
}

data "http" "my_public_ip" {
  url = "http://ipv4.icanhazip.com"
}

# Zone permissions
data "cloudflare_api_token_permission_groups_list" "dns_write" {
  name  = "DNS Write"
  scope = "com.cloudflare.api.account.zone"
}

# Token allowed to edit DNS entries and TLS certs for specific zone.
resource "cloudflare_api_token" "dns_tls_edit_token" {
  name = "dns_tls_edit"

  policies = [{
    effect = "allow"
    permission_groups = [
      { id = data.cloudflare_api_token_permission_groups_list.dns_write.result[0].id },
    ]
    resources = jsonencode({
      "com.cloudflare.api.account.zone.*" = "*"
    })
  }]
}

module "pleasenoddos_dns" {
  source = "./cloudflare_dns"

  root_domain   = local.pleasenoddos_root_domain
  a_records     = local.pleasenoddos_a_records
  cname_records = local.pleasenoddos_cname_records
}

module "computersbarelywork_dns" {
  source = "./cloudflare_dns"

  root_domain   = "computersbarely.work"
  a_records     = {}
  cname_records = {}
}

module "chunafishy_dns" {
  source = "./cloudflare_dns"

  root_domain   = local.chunafishy_root_domain
  a_records     = local.chunafishy_a_records
  cname_records = {}
}
