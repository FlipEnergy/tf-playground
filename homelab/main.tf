module "letsencrypt" {
  source = "./letsencrypt"

  my_domain          = var.my_domain
  my_email           = var.my_email
  cloudflare_api_key = var.cloudflare_api_key
}

module "oracle_homelab" {
  source = "./oracle"

  tenancy_ocid    = var.tenancy_ocid
  my_email        = var.my_email
  cert_issuer_pem = module.letsencrypt.issuer_pem
  cert_pem        = module.letsencrypt.certificate
  cert_priv_key   = module.letsencrypt.private_key
}

module "cloudflare_dns" {
  source = "./cloudflare_dns"

  my_domain              = var.my_domain
  my_public_ip           = var.my_public_ip
  oracle_arm_1_public_ip = module.oracle_homelab.oracle_arm_1_public_ip
}

# Uncomment when backblaze allows importing
# module "backblaze" {
#   source = "./backblaze"
# }
