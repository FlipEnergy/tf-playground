data "oci_core_images" "ubuntu_images" {
  compartment_id           = var.tenancy_ocid
  operating_system         = var.vm_os
  operating_system_version = var.vm_os_version
  shape                    = var.vm_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "ok8s_node" {
  display_name        = var.display_name
  availability_domain = var.availability_domain
  compartment_id      = var.tenancy_ocid
  shape               = var.vm_shape
  source_details {
    source_id   = data.oci_core_images.ubuntu_images.images[0].id
    source_type = "image"
  }
  create_vnic_details {
    assign_public_ip = false
    subnet_id        = var.subnet_id
  }
  metadata = {
    ssh_authorized_keys = file(var.ssh_priv_key_path)
  }
  preserve_boot_volume = false
}

data "oci_core_vnic_attachments" "ok8s_node_vnics" {
  compartment_id      = var.tenancy_ocid
  availability_domain = var.availability_domain
  instance_id         = oci_core_instance.ok8s_node.id
}

data "oci_core_vnic" "ok8s_node_vnic1" {
  vnic_id = data.oci_core_vnic_attachments.ok8s_node_vnics.vnic_attachments[0].vnic_id
}

data "oci_core_private_ips" "ok8s_node_primary_priv_ips" {
  vnic_id = data.oci_core_vnic.ok8s_node_vnic1.id
}

resource "oci_core_public_ip" "node_public_ip" {
    display_name = var.display_name
    compartment_id = var.tenancy_ocid
    lifetime = "RESERVED"
    private_ip_id = data.oci_core_private_ips.ok8s_node_primary_priv_ips.private_ips[0].id
}
