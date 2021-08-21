module "cloudflare_dns" {
  source = "./cloudflare_dns"

  my_public_ip = var.my_public_ip
}

module "oracle_homelab" {
  source = "./oracle"

  tenancy_ocid = var.tenancy_ocid
  my_email = var.my_email
}
