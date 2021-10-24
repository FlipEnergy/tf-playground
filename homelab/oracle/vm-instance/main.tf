data "oci_core_images" "ubuntu_images" {
  compartment_id           = var.tenancy_ocid
  operating_system         = var.vm_os
  operating_system_version = var.vm_os_version
  shape                    = var.vm_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "vm_instance" {
  display_name        = var.display_name
  availability_domain = var.availability_domain
  compartment_id      = var.tenancy_ocid
  shape               = var.vm_shape
  shape_config {
    ocpus         = var.vm_ocpus
    memory_in_gbs = var.vm_memory_gbs
  }
  source_details {
    source_id               = var.vm_image_override != "" ? var.vm_image_override : data.oci_core_images.ubuntu_images.images[0].id
    source_type             = "image"
    boot_volume_size_in_gbs = 50
  }
  create_vnic_details {
    assign_public_ip = false
    subnet_id        = var.subnet_id
  }
  metadata = {
    ssh_authorized_keys = file(var.ssh_pub_key_path)
  }
  preserve_boot_volume = false
}
