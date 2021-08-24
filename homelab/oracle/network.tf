resource "oci_core_vcn" "homelab_vcn" {
  display_name   = "Homelab VCN"
  compartment_id = var.tenancy_ocid

  cidr_blocks = ["10.0.0.0/16"]
}

resource "oci_core_security_list" "https_security_list" {
  display_name   = "HTTPS Security List"
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.homelab_vcn.id

  ingress_security_rules {
    description = "Allow K8s http traffic"
    protocol    = 6 # TCP
    source      = "0.0.0.0/0"

    tcp_options {
      max = 80
      min = 80
    }
  }
  ingress_security_rules {
    description = "Allow K8s https traffic"
    protocol    = 6 # TCP
    source      = "0.0.0.0/0"
    tcp_options {
      min = 443
      max = 443
    }
  }
}

resource "oci_core_security_list" "pihole_security_list" {
  display_name   = "Pi-Hole Security List"
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.homelab_vcn.id

  ingress_security_rules {
    description = "Allow Pi-Hole DNS traffic"
    protocol    = 17 # UDP
    source      = "0.0.0.0/0"
    udp_options {
      min = 53
      max = 53
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

resource "oci_core_subnet" "https_subnet" {
  display_name              = "HTTPS Subnet"
  cidr_block                = "10.0.69.0/24"
  compartment_id            = var.tenancy_ocid
  vcn_id                    = oci_core_vcn.homelab_vcn.id
  prohibit_internet_ingress = false
  route_table_id            = oci_core_route_table.route_table.id
  security_list_ids = [
    oci_core_vcn.homelab_vcn.default_security_list_id,
    oci_core_security_list.https_security_list.id
  ]
}

resource "oci_core_subnet" "pihole_subnet" {
  display_name              = "Pi-Hole Subnet"
  cidr_block                = "10.0.70.0/24"
  compartment_id            = var.tenancy_ocid
  vcn_id                    = oci_core_vcn.homelab_vcn.id
  prohibit_internet_ingress = false
  route_table_id            = oci_core_route_table.route_table.id
  security_list_ids = [
    oci_core_vcn.homelab_vcn.default_security_list_id,
    oci_core_security_list.pihole_security_list.id
  ]
}
