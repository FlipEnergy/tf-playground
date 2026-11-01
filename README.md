# tf-playground
A repo for my Terraform configurations

## requirements
- [mise](https://mise.jdx.dev/), which installs the Terraform version pinned in `homelab/mise.toml` (run it with `mise exec -- terraform ...` from `homelab/`)
- `homelab/terraform.tfvars` and `homelab/backend.tf`, created from the `*.template` files

## What it manages
- Cloudflare zones, zone settings, DNS records and an API token for DNS edits
- Backblaze B2 bucket and app key for TrueNAS backups
- Oracle Cloud object storage bucket that holds the Terraform state, plus a $1/month budget alert

## Oracle Cloud
- https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-provider/01-summary.htm
- https://registry.terraform.io/providers/hashicorp/oci/latest/docs
- https://github.com/terraform-providers/terraform-provider-oci

# My homelab setup
![Homelab DIagram](https://pleasenoddos.com/img/homelab.jpg)
