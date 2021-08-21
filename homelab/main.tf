module "cloudflare_dns" {
  source = "./cloudflare_dns"

  my_domain    = var.my_domain
  my_public_ip = var.my_public_ip
}

module "letsencrypt" {
  source = "./letsencrypt"

  my_domain          = var.my_domain
  my_email           = var.my_email
  cloudflare_api_key = var.cloudflare_api_key
}

module "oracle_homelab" {
  source = "./oracle"

  tenancy_ocid = var.tenancy_ocid
  my_email     = var.my_email
}
