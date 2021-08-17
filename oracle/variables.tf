variable "tenancy_ocid" {
  sensitive = true
}

variable "user_ocid" {
  sensitive = true
}

variable "private_key_path" {
  default = "~/.oci/oracle_public.pem"
}

variable "fingerprint" {
  sensitive = true
}

variable "region" {
  default = "ca-toronto-1"
}
