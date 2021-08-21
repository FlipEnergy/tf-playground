output "certificate" {
  value     = module.letsencrypt.certificate
  sensitive = true
}

output "private_key" {
  value     = module.letsencrypt.private_key
  sensitive = true
}
