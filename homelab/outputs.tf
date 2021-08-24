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

output "oracle_arm_1_public_ip" {
  value = module.oracle_homelab.oracle_arm_1_public_ip
}
