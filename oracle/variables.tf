variable "tenancy_ocid" {
  sensitive = true
}

variable "user_ocid" {
  sensitive = true
}

variable "oci_private_key_path" {
  default = "../../../.oci/oracle.pem"
}

variable "fingerprint" {
  sensitive = true
}

variable "region" {
  default = "ca-toronto-1"
}
