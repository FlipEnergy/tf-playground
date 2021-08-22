output "certificate" {
  value     = module.letsencrypt.certificate
  sensitive = true
}

output "private_key" {
  value     = module.letsencrypt.private_key
  sensitive = true
}

output "ok8s_arm_node_1_public_ip" {
  value = module.oracle_homelab.ok8s_arm_node_1_public_ip
}

output "ok8s_arm_node_2_public_ip" {
  value = module.oracle_homelab.ok8s_arm_node_2_public_ip
}

output "ok8s_arm_node_1_private_ip" {
  value = module.oracle_homelab.ok8s_arm_node_1_private_ip
}

output "ok8s_arm_node_2_private_ip" {
  value = module.oracle_homelab.ok8s_arm_node_2_private_ip
}
