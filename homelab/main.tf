module "oracle_homelab" {
  source = "./oracle"

  tenancy_ocid = var.tenancy_ocid
  my_email     = var.my_email
}

module "backblaze" {
  source = "./backblaze"
}
