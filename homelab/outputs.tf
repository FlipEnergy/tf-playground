output "certificate_chain" {
  value     = "${module.letsencrypt.certificate}${module.letsencrypt.issuer_pem}"
  sensitive = true
}

output "private_key" {
  value     = module.letsencrypt.private_key
  sensitive = true
}

output "pi_hole_public_ip" {
  value = module.oracle_homelab.pi_hole_public_ip
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

output "oracle_lb_public_ip" {
  value = module.oracle_homelab.lb_public_ip
}
