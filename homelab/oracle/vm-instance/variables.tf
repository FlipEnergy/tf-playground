variable "display_name" {}

variable "tenancy_ocid" {
  sensitive = true
}

variable "vm_shape" {
  default = "VM.Standard.E2.1.Micro"
}

variable "vm_ocpus" {
  default = 1
}

variable "vm_memory_gbs" {
  default = 1
}

variable "vm_image_override" {
  default = ""
}

variable "vm_os" {
  default = "Canonical Ubuntu"
}

variable "vm_os_version" {
  default = "20.04"
}

variable "boot_volume_size_in_gbs" {
  default = 50
}

variable "availability_domain" {}

variable "subnet_id" {}

variable "ssh_priv_key_path" {
  default = "/home/dennis/.ssh/oracle_ssh.pub"
}
