variable "display_name" {}

variable "tenancy_ocid" {
  sensitive = true
}

variable "vm_shape" {
  default = "VM.Standard.E2.1.Micro"
}

variable "vm_os" {
  default = "Canonical Ubuntu"
}

variable "vm_os_version" {
  default = "20.04 Minimal"
}

variable "availability_domain" {}

variable "subnet_id" {}

variable "ssh_priv_key_path" {
  default = "../../../.ssh/id_rsa.pub"
}
