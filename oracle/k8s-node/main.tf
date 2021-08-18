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
    assign_public_ip = true
    subnet_id        = var.subnet_id
  }
  metadata = {
    ssh_authorized_keys = file(var.ssh_priv_key_path)
  }
  preserve_boot_volume = false
}
