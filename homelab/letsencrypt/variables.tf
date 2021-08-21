variable "my_domain" {}

variable "my_email" {}

variable "acme_dns_challenge_provider" {
  default = "cloudflare"
}

variable "cloudflare_api_key" {
  sensitive = true
}