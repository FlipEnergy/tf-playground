data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.tenancy_ocid
}

module "ok8s_amd_node_1" {
  source = "./ok8s-node"

  display_name        = "Oracle K8s AMD Node 1"
  tenancy_ocid        = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  subnet_id           = oci_core_subnet.homelab_subnet.id
}

module "ok8s_amd_node_2" {
  source = "./ok8s-node"

  display_name        = "Oracle K8s AMD Node 2"
  tenancy_ocid        = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  subnet_id           = oci_core_subnet.homelab_subnet.id
}

module "ok8s_arm_node_1" {
  source = "./ok8s-node"

  display_name        = "Oracle K8s ARM Node 1"
  tenancy_ocid        = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  subnet_id           = oci_core_subnet.homelab_subnet.id
  vm_shape            = "VM.Standard.A1.Flex"
  vm_ocpus            = 4
  vm_memory_gbs       = 24
}
