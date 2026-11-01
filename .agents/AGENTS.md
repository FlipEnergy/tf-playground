# tf-playground — agent context

Terraform for a personal homelab's cloud resources (owner: FlipEnergy / Dennis Zhang). Single root module: `homelab/`.

## Ground rules for agents (read first)

**Secrets**
- Never commit secrets: credentials, tokens, private keys, kubeconfigs, `.tfvars`, decrypted sops output, or anything that looks like one. If a change would add one, stop and ask.
- Before committing, review the staged diff (`git diff --cached`) for secret-looking values and for files that should be ignored. Never use `git add -f` on an ignored file, and never weaken `.gitignore` to make a file committable.
- Never put secret values into tracked files, commit messages, PR descriptions, logs, or chat output — not even partially or "redacted by hand".
- Encrypted files (`*.enc.yml`, sops `*-secrets.yaml`) may be read as-is, but only change them with the proper tool (`sops`); never decrypt them unless asked.

**Git-ignored files**
- Do not read, print, search, or open git-ignored files directly unless the user specifically asks for that file. They are often local secrets or decrypted copies (e.g. `*.dec.yml`, `*.yaml.dec`, `terraform.tfvars`, `backend.tf`, `*.key`, `*.pem`).
- Exclude them from searches (prefer `git ls-files` / `git grep`, or tools that respect `.gitignore`). Check with `git check-ignore -v <path>` if unsure.
- Generated build output that is ignored (e.g. `public/`, `.terraform/`) may be listed, but still don't read its contents unless needed for the task and asked.

## What it manages

- **Cloudflare** (`cloudflare/cloudflare ~> 4.0`): zones + A/CNAME records for `pleasenoddos.com`, `computersbarely.work`, `chunafishy.com` via the local `cloudflare_dns` module; a scoped API token `dns_tls_edit` (used by cert-manager / cf-ddns in `k8s-homelab`).
- **Backblaze B2** (`backblaze/b2`): `flipenergy-homelab-truenas-backup` bucket + app key for TrueNAS backups.
- **Oracle Cloud** (`hashicorp/oci ~> 6.0`): the `terraform-state` object storage bucket that holds this repo's state, and a $1/month budget alert. The `vm-instance` module and network are kept but the VM is commented out.

## Layout (`homelab/`)

| File | Purpose |
|---|---|
| `dns_records.tf` | DNS record maps (`locals`) and module calls per zone. A records point at the current public IP fetched from `icanhazip.com` at plan time. Add `proxied = false` to bypass Cloudflare proxy (e.g. WireGuard). |
| `main.tf` | Oracle and Backblaze module calls, `moved` blocks. |
| `providers.tf`, `variables.tf`, `versions.tf`, `outputs.tf` | Standard. Terraform pinned to `~> 1.7.0` (`mise.toml` installs 1.7.0). |
| `cloudflare_dns/`, `backblaze/`, `oracle/` (+ `oracle/vm-instance/`) | Local modules. |
| `*.template` | Templates for the gitignored `terraform.tfvars` and `backend.tf`. |
| `Makefile` | `make get-b2-key`, `make get-cf-token` — read sensitive outputs from state via `terraform show -json`. |

## Secrets — important

- `homelab/terraform.tfvars` and `homelab/backend.tf` are **gitignored and may exist locally with real credentials** (the backend address is an Oracle pre-authenticated URL with write access to state). Never print, copy, or commit their contents; never inline them into tracked files.
- The OCI private key is read from `~/.ssh/oracle.pem` by default.
- Outputs `b2_app_key` and `cloudflare_dns_edit_token` are sensitive.

## Workflow

- Run from `homelab/`: `terraform init`, `terraform validate`, `terraform fmt -recursive`, `terraform plan`.
- `terraform apply` changes real DNS/cloud resources — only with explicit approval.
- CI (`terraform` pipeline in sibling `concourse-pipelines`) runs on push to `main` and every Friday: `init`, `validate`, `fmt -recursive -check -diff`, `plan -lock=false -detailed-exitcode`. **Unformatted code or any pending diff fails the job**, so run `terraform fmt -recursive` and expect apply to be done manually by the owner.
- Use `moved {}` blocks when refactoring resource addresses to avoid destroy/recreate.
- Renovate (`renovate.json`) bumps provider versions.

## Cross-repo

- New public hostnames for apps in `k8s-homelab` need an entry in `pleasenoddos_a_records`.
