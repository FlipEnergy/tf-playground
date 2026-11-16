# tf-playground
A repo for my OpenTofu (Terraform-compatible) configurations

## requirements
- [mise](https://mise.jdx.dev/), which installs the OpenTofu version pinned in `homelab/mise.toml` (run it with `mise exec -- tofu ...` from `homelab/`)
- `homelab/terraform.tfvars` and `homelab/backend.tf`, created from the `*.template` files

## What it manages
- Cloudflare zones, zone settings, DNS records and an API token for DNS edits
- Backblaze B2 bucket and app key for TrueNAS backups

## State
State lives in a private Backblaze B2 bucket (S3-compatible backend) with a bucket-scoped key, and is encrypted client-side with OpenTofu state encryption (`homelab/encryption.tf`). The passphrase is `state_passphrase` in `terraform.tfvars`; without it the state can't be read.

## Oracle Cloud (disabled)
All OCI resources were destroyed in Nov 2026. The module call, provider and variables are commented out; the `oracle/` module is kept for reference.
- https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-provider/01-summary.htm
- https://registry.terraform.io/providers/hashicorp/oci/latest/docs
- https://github.com/terraform-providers/terraform-provider-oci

# My homelab setup
![Homelab DIagram](https://pleasenoddos.com/img/homelab.jpg)
