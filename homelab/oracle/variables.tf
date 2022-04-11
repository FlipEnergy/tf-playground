variable "tenancy_ocid" {
  sensitive = true
}

variable "my_email" {}

variable "cert_issuer_pem" {}

variable "cert_pem" {}

variable "cert_priv_key" {
  sensitive = true
}
