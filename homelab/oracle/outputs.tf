output "pi_hole_public_ip" {
  value = module.pi_hole.public_ip
}

output "ok8s_arm_node_1_public_ip" {
  value = module.ok8s_arm_node_1.public_ip
}

output "ok8s_arm_node_2_public_ip" {
  value = module.ok8s_arm_node_2.public_ip
}

output "ok8s_amd_node_1_public_ip" {
  value = module.ok8s_amd_node_1.public_ip
}

output "ok8s_arm_node_1_private_ip" {
  value = module.ok8s_arm_node_1.private_ip
}

output "ok8s_arm_node_2_private_ip" {
  value = module.ok8s_arm_node_2.private_ip
}

output "ok8s_amd_node_1_private_ip" {
  value = module.ok8s_amd_node_1.private_ip
}