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
