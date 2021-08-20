locals {
  rules = [
    {
      description       = "Allow internet ingress"
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = oci_core_internet_gateway.internet_gateway.id
    }
  ]
}

resource "oci_core_vcn" "homelab_vcn" {
  compartment_id = var.tenancy_ocid
  display_name   = "Homelab VCN"

  cidr_blocks = ["10.0.0.0/16"]
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.homelab_vcn.id
  display_name   = "Homelab Gateway"
  enabled        = true
}

resource "oci_core_route_table" "route_table" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.homelab_vcn.id
  display_name   = "Homelab Gateway Route Table"

  dynamic "route_rules" {
    for_each = local.rules
    content {
      description       = route_rules.value.description
      destination       = route_rules.value.destination
      destination_type  = route_rules.value.destination_type
      network_entity_id = route_rules.value.network_entity_id
    }
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
