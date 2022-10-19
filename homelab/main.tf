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

module "cloudflare_dns" {
  source = "./cloudflare_dns"

  my_domain              = var.my_domain
  oracle_arm_1_public_ip = module.oracle_homelab.oracle_arm_1_public_ip
}

module "backblaze" {
  source = "./backblaze"
}

module "homelab_k8s" {
  source = "./kubernetes"
  providers = {
    kubernetes = kubernetes.homelab
  }

  cert = "${module.letsencrypt.certificate}${module.letsencrypt.issuer_pem}"
  key  = module.letsencrypt.private_key
}

module "oracle_k8s" {
  source = "./kubernetes"
  providers = {
    kubernetes = kubernetes.oracle
  }

  cert = "${module.letsencrypt.certificate}${module.letsencrypt.issuer_pem}"
  key  = module.letsencrypt.private_key
}
