terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "~> 4.39.0"
    }
  }
  backend "http" {
    # Update address and ignore changes with `git update-index --skip-worktree versions.tf`
    # Undo ignore to commit new changes with `git update-index --no-skip-worktree versions.tf`
    address       = "<REDACTED>"
    update_method = "PUT"
  }
  required_version = "~> 1.0.4"
}
