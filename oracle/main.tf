data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.tenancy_ocid
}

module "ok8s_arm_node_1" {
  source = "./vm-instance"

  display_name            = "Oracle K8s ARM Node 1"
  tenancy_ocid            = var.tenancy_ocid
  availability_domain     = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  subnet_id               = oci_core_subnet.homelab_subnet.id
  vm_shape                = "VM.Standard.A1.Flex"
  vm_ocpus                = 4
  vm_memory_gbs           = 24
  boot_volume_size_in_gbs = 100
}

module "pi_hole" {
  source = "./vm-instance"

  display_name        = "Pi-Hole"
  tenancy_ocid        = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  subnet_id           = oci_core_subnet.homelab_subnet.id
}
