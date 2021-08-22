terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.5"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.25"
    }
    oci = {
      source  = "hashicorp/oci"
      version = "~> 4.40"
    }
  }
  required_version = "~> 1.0.4"
}
