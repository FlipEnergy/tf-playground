resource "oci_core_vcn" "homelab_vcn" {
  compartment_id = var.tenancy_ocid
  display_name   = "Homelab VCN"

  cidr_blocks = ["10.0.0.0/16"]
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.tenancy_ocid
  vcn_id = oci_core_vcn.homelab_vcn.id
  display_name = "Homelab Gateway"
  enabled = true
}
resource "oci_core_route_table" "route_table" {
  compartment_id = var.tenancy_ocid
  vcn_id = oci_core_vcn.homelab_vcn.id
  display_name = "Homelab Gateway Route Table"
  route_rules {
      network_entity_id = oci_core_internet_gateway.internet_gateway.id
      description = "Allow internet ingress"
      destination = "0.0.0.0/0"
      destination_type = "CIDR_BLOCK"
  }
}

resource "oci_core_subnet" "homelab_subnet" {
  display_name              = "Homelab Subnet"
  cidr_block                = "10.0.69.0/24"
  compartment_id            = var.tenancy_ocid
  vcn_id                    = oci_core_vcn.homelab_vcn.id
  prohibit_internet_ingress = false
  route_table_id            = oci_core_route_table.route_table.id
}

data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.tenancy_ocid
}

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
