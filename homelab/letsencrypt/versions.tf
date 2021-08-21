terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
    }
    acme = {
      source = "vancluever/acme"
    }
  }
}
