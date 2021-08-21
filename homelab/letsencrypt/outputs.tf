output "certificate" {
  value     = "${acme_certificate.cert.certificate_pem}${acme_certificate.cert.issuer_pem}"
  sensitive = true
}

output "private_key" {
  value     = acme_certificate.cert.private_key_pem
  sensitive = true
}
