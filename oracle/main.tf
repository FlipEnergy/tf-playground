resource "oci_core_vcn" "homelab_vcn" {
  compartment_id = var.tenancy_ocid
  display_name   = "Homelab"

  cidr_blocks = ["10.0.0.0/16"]
}

resource "oci_core_subnet" "homelab_subnet" {
  display_name              = "Homelab"
  cidr_block                = "10.0.69.0/24"
  compartment_id            = var.tenancy_ocid
  vcn_id                    = oci_core_vcn.homelab_vcn.id
  prohibit_internet_ingress = false
}

data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.tenancy_ocid
}

module "ok8s_node_1" {
  source = "./k8s-node"

  display_name        = "Oracle K8s Node 1"
  tenancy_ocid        = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  subnet_id           = oci_core_subnet.homelab_subnet.id
}

module "ok8s_node_2" {
  source = "./k8s-node"

  display_name        = "Oracle K8s Node 2"
  tenancy_ocid        = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  subnet_id           = oci_core_subnet.homelab_subnet.id
}
