output "ok8s_node_public_ip" {
  value = oci_core_public_ip.node_public_ip.ip_address
}
