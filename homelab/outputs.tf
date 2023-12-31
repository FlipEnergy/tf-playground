# output "pi_hole_public_ip" {
#   value = module.oracle_homelab.pi_hole_public_ip
# }

output "oracle_arm_1_public_ip" {
  value = module.oracle_homelab.oracle_arm_1_public_ip
}

output "b2_bucket_name" {
  value = module.backblaze.bucket_name
}

output "b2_app_key_id" {
  value = module.backblaze.app_key_id
}

output "b2_app_key" {
  value     = module.backblaze.app_key
  sensitive = true
}

output "cloudflare_dns_edit_token" {
  value     = cloudflare_api_token.dns_tls_edit_token.value
  sensitive = true
}
