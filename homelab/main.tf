module "oracle_homelab" {
  source = "./oracle"

  tenancy_ocid = var.tenancy_ocid
  my_email     = var.my_email
}

module "backblaze" {
  source = "./backblaze"
}

moved {
  from = module.oracle_homelab.module.oracle_arm_1.oci_objectstorage_bucket.terraform_state
  to   = module.oracle_homelab.oci_objectstorage_bucket.terraform_state
}