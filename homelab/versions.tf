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
  backend "http" {
    # Update address and ignore changes with `git update-index --skip-worktree versions.tf`
    # Undo ignore to commit new changes with `git update-index --no-skip-worktree versions.tf`
    address       = "https://objectstorage.ca-toronto-1.oraclecloud.com/p/xehE9K_iQ5DhoK_O7zMjOWzRQt3w2IYSUzVt49p7WGSNjX1QmWVOJ1cR_zCJQMda/n/yzitcaqqr4r5/b/terraform-state/o/terraform.tfstate"
    update_method = "PUT"
  }
  required_version = "~> 1.0.4"
}
