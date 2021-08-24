output "pi_hole_public_ip" {
  value = module.pi_hole.public_ip
}

output "oracle_arm_1_public_ip" {
  value = module.oracle_arm_1.public_ip
}

output "oracle_arm_1_private_ip" {
  value = module.oracle_arm_1.private_ip
}
