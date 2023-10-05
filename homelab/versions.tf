terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    oci = {
      source  = "hashicorp/oci"
      version = "~> 5.0"
    }
    b2 = {
      source  = "backblaze/b2"
      version = "~> 0.8"
    }
  }
  required_version = "~> 1.6.0"
}
