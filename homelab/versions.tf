terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.11"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.26"
    }
    oci = {
      source  = "hashicorp/oci"
      version = "~> 4.96"
    }
    b2 = {
      source  = "backblaze/b2"
      version = "~> 0.8"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.14"
    }
  }
  required_version = "~> 1.3.2"
}
