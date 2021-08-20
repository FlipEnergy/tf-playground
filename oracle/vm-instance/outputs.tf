output "private_ip" {
  value = oci_core_instance.vm_instance.private_ip
}
output "public_ip" {
  value = oci_core_public_ip.node_public_ip.ip_address
}
