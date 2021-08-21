resource "tls_private_key" "priv_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.priv_key.private_key_pem
  email_address   = var.my_email
}

resource "acme_certificate" "cert" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = var.my_domain
  subject_alternative_names = ["*.${var.my_domain}"]

  recursive_nameservers = ["1.1.1.1:53"]

  dns_challenge {
    provider = var.acme_dns_challenge_provider
    config = {
      CLOUDFLARE_EMAIL   = var.my_email
      CLOUDFLARE_API_KEY = var.cloudflare_api_key
    }
  }
}
