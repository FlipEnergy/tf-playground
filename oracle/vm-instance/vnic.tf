data "oci_core_vnic_attachments" "vm_instance_vnics" {
  compartment_id      = var.tenancy_ocid
  availability_domain = var.availability_domain
  instance_id         = oci_core_instance.vm_instance.id
}

data "oci_core_vnic" "vm_instance_vnic1" {
  vnic_id = data.oci_core_vnic_attachments.vm_instance_vnics.vnic_attachments[0].vnic_id
}

data "oci_core_private_ips" "vm_instance_primary_priv_ips" {
  vnic_id = data.oci_core_vnic.vm_instance_vnic1.id
}

resource "oci_core_public_ip" "node_public_ip" {
  display_name   = var.display_name
  compartment_id = var.tenancy_ocid
  lifetime       = "RESERVED"
  private_ip_id  = data.oci_core_private_ips.vm_instance_primary_priv_ips.private_ips[0].id
}
