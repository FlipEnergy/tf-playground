data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.tenancy_ocid
}

module "oracle_arm_1" {
  source = "./vm-instance"

  display_name        = "Oracle ARM 1"
  tenancy_ocid        = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  subnet_id           = oci_core_subnet.https_subnet.id
  vm_shape            = "VM.Standard.A1.Flex"
  # vm_image_override   = "ocid1.image.oc1.ca-toronto-1.aaaaaaaae4fomnpmoh3opjlqth3grcjesn725pb2vz6gp6t46oyww274vmjq"
  vm_ocpus            = 4
  vm_memory_gbs       = 24
}
