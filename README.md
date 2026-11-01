# tf-playground
A repo for my Terraform configurations

## requirements
- [mise](https://mise.jdx.dev/), which installs the Terraform version pinned in `homelab/mise.toml`

## What it manages
- Cloudflare DNS records and an API token for DNS edits
- Backblaze B2 bucket and app key for TrueNAS backups
- Oracle Cloud object storage bucket that holds the Terraform state

## Oracle Cloud
- https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-provider/01-summary.htm
- https://registry.terraform.io/providers/hashicorp/oci/latest/docs
- https://github.com/terraform-providers/terraform-provider-oci

# My homelab setup
![Homelab DIagram](https://pleasenoddos.com/img/homelab.jpg)
