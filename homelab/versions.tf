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
    b2 = {
      source  = "backblaze/b2"
      version = "~> 0.7"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.9"
    }
  }
  required_version = "~> 1.1.3"
}
