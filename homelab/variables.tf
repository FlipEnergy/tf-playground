variable "my_email" {
  default = "dennis.zhang.nrg@gmail.com"
}

variable "my_domain" {
  default = "pleasenoddos.com"
}

variable "cloudflare_api_key" {
  sensitive = true
}

variable "my_public_ip" {
  default = "24.16.205.63"
}

variable "tenancy_ocid" {
  sensitive = true
}

variable "user_ocid" {
  sensitive = true
}

variable "oci_private_key_path" {
  default = "/home/dennis/.ssh/oracle.pem"
}

variable "fingerprint" {
  sensitive = true
}

variable "region" {
  default = "ca-toronto-1"
}

variable "b2_app_key" {
  sensitive = true
}

variable "b2_key_id" {
  sensitive = true
}
