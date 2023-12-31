module "oracle_homelab" {
  source = "./oracle"

  tenancy_ocid = var.tenancy_ocid
  my_email     = var.my_email
}

module "cloudflare_dns" {
  source = "./cloudflare_dns"

  my_domain              = var.my_domain
  oracle_arm_1_public_ip = module.oracle_homelab.oracle_arm_1_public_ip
}

module "backblaze" {
  source = "./backblaze"
}

# Cloudflare

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
