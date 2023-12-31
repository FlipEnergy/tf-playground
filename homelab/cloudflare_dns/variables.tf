variable "root_domain" {
  type = string
}

variable "a_records" {
  type = map(any)
}

variable "cname_records" {
  type = map(any)
}
