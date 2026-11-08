terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
    oci = {
      source  = "hashicorp/oci"
      version = "~> 9.0"
    }
    b2 = {
      source  = "backblaze/b2"
      version = "~> 0.14"
    }
  }
  required_version = "~> 1.17.0"
}
