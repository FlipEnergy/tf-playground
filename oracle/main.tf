locals {
  vm_shape      = "VM.Standard.E2.1.Micro"
  vm_os         = "Canonical Ubuntu"
  vm_os_version = "20.04 Minimal"
}

resource "oci_core_vcn" "homelab_vcn" {
  compartment_id = var.tenancy_ocid
  display_name   = "Homelab"

  cidr_blocks = ["10.0.0.0/16"]
}

resource "oci_core_subnet" "homelab_subnet" {
  display_name = "Homelab"
  cidr_block = "10.0.69.0/24"
  compartment_id = var.tenancy_ocid
  vcn_id = oci_core_vcn.homelab_vcn.id
}

data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "ubuntu_images" {
  compartment_id           = var.tenancy_ocid
  operating_system         = local.vm_os
  operating_system_version = local.vm_os_version
  shape                    = local.vm_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "ubuntu_1" {
  display_name        = "Ubuntu 1"
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  compartment_id      = var.tenancy_ocid
  shape               = local.vm_shape
  source_details {
    source_id   = data.oci_core_images.ubuntu_images.images[0].id
    source_type = "image"
  }
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.homelab_subnet.id
  }
  # metadata = {
  #   ssh_authorized_keys = file("<ssh-public-key-path>")
  # }
  preserve_boot_volume = false
}
