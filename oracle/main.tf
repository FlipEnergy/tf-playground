data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.tenancy_ocid
}

# module "onfs_node_1" {
#   source = "./onfs-node"
#
#   display_name        = "Oracle NFS Node 1"
#   tenancy_ocid        = var.tenancy_ocid
#   availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
#   subnet_id           = oci_core_subnet.homelab_subnet.id
# }

module "ok8s_node_1" {
  source = "./ok8s-node"

  display_name        = "Oracle K8s Node 1"
  tenancy_ocid        = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  subnet_id           = oci_core_subnet.homelab_subnet.id
}

module "ok8s_node_2" {
  source = "./ok8s-node"

  display_name        = "Oracle K8s Node 2"
  tenancy_ocid        = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  subnet_id           = oci_core_subnet.homelab_subnet.id
}

module "ok8s_node_3" {
  source = "./ok8s-node"

  display_name        = "Oracle K8s Node 3"
  tenancy_ocid        = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  subnet_id           = oci_core_subnet.homelab_subnet.id
  vm_shape            = "VM.Standard.A1.Flex"
  vm_ocpus            = 4
  vm_memory_gbs       = 24
}
