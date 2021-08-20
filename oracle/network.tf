resource "oci_core_vcn" "homelab_vcn" {
  display_name   = "Homelab VCN"
  compartment_id = var.tenancy_ocid

  cidr_blocks = ["10.0.0.0/16"]
}

resource "oci_core_security_list" "homelab_security_list" {
  display_name   = "Homelab Security List"
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.homelab_vcn.id

  dynamic "ingress_security_rules" {
    for_each = [
      {
        description = "Allow K8s API traffic"
        protocol    = 6 # TCP
        source      = "0.0.0.0/0"
        tcp_options = {
          max = 6443
          min = 6443
        }
      },
      {
        description = "Allow K8s Ectd traffic"
        protocol    = 6 # TCP
        source      = "0.0.0.0/0"
        tcp_options = {
          max = 2380
          min = 2379
        }
      }
    ]
    content {
      description = ingress_security_rules.value.description
      protocol    = ingress_security_rules.value.protocol
      source      = ingress_security_rules.value.source
      tcp_options {
        min = ingress_security_rules.value.tcp_options.min
        max = ingress_security_rules.value.tcp_options.max
      }
    }
  }
}

resource "oci_core_internet_gateway" "internet_gateway" {
  display_name   = "Homelab Gateway"
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.homelab_vcn.id
  enabled        = true
}

resource "oci_core_route_table" "route_table" {
  display_name   = "Homelab Gateway Route Table"
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.homelab_vcn.id

  route_rules {
    description       = "Allow internet ingress"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

resource "oci_core_subnet" "homelab_subnet" {
  display_name              = "Homelab Subnet"
  cidr_block                = "10.0.69.0/24"
  compartment_id            = var.tenancy_ocid
  vcn_id                    = oci_core_vcn.homelab_vcn.id
  prohibit_internet_ingress = false
  route_table_id            = oci_core_route_table.route_table.id
  security_list_ids         = [
    oci_core_vcn.homelab_vcn.default_security_list_id,
    oci_core_security_list.homelab_security_list.id
  ]
}
