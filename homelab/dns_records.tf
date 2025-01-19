locals {
  my_public_ip             = chomp(data.http.my_public_ip.response_body)
  pleasenoddos_root_domain = "pleasenoddos.com"
  pleasenoddos_a_records = {
    "root" : {
      name = local.pleasenoddos_root_domain
      ip   = module.oracle_homelab.oracle_arm_1_public_ip
    },
    "www" : {
      name = "www"
      ip   = module.oracle_homelab.oracle_arm_1_public_ip
    },
    "Airsonic-refix" : {
      name = "music"
      ip   = local.my_public_ip
    },
    "Bitwarden" : {
      name = "bitwarden"
      ip   = local.my_public_ip
    },
    "Flatnotes" : {
      name = "notes"
      ip   = local.my_public_ip
    },
    "Hastebin" : {
      name = "haste"
      ip   = module.oracle_homelab.oracle_arm_1_public_ip
    },
    "Influxdb 2" : {
      name = "influx"
      ip   = module.oracle_homelab.oracle_arm_1_public_ip
    },
    "Kube Ops View" : {
      name = "kube"
      ip   = local.my_public_ip
    },
    "Gonic" : {
      name = "gonic"
      ip   = local.my_public_ip
    },
    "Nextcloud" : {
      name = "cloud"
      ip   = local.my_public_ip
    },
    "Stirling PDF" : {
      name = "pdf"
      ip   = module.oracle_homelab.oracle_arm_1_public_ip
    },
    "Wireguard" : {
      name    = "wg"
      ip      = local.my_public_ip
      proxied = false
    }
    "Wireguard Canada" : {
      name    = "wgc"
      ip      = module.oracle_homelab.oracle_arm_1_public_ip
      proxied = false
    }
  }
  pleasenoddos_cname_records = {
    "status page" : {
      name  = "status"
      cname = "statuspage.freshping.io"
    }
  }
}

data "http" "my_public_ip" {
  url = "http://ipv4.icanhazip.com"
}

# Zone permissions
data "cloudflare_api_token_permission_groups" "all" {}

# Token allowed to edit DNS entries and TLS certs for specific zone.
resource "cloudflare_api_token" "dns_tls_edit_token" {
  name = "dns_tls_edit"

  policy {
    permission_groups = [
      data.cloudflare_api_token_permission_groups.all.zone["DNS Write"],
    ]
    resources = {
      "com.cloudflare.api.account.zone.*" = "*"
    }
  }
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
