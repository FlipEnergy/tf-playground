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

Provider and Terraform version constraints live in `homelab/versions.tf` (the source of truth — don't duplicate version numbers here).

- **Cloudflare** (`cloudflare/cloudflare`, v4): zones, zone settings (`cloudflare_zone_settings_override`: always HTTPS, websockets, strict SSL, min TLS 1.2) and A/CNAME records for `pleasenoddos.com`, `computersbarely.work`, `chunafishy.com` via the local `cloudflare_dns` module; a scoped API token `dns_tls_edit` (used by cert-manager / cf-ddns in `k8s-homelab`). Cloudflare v5 removes `cloudflare_zone_settings_override` and `cloudflare_record`, so a v5 upgrade means rewriting that module. The `ignore_changes = [initial_settings]` on the zone settings triggers a "Redundant ignore_changes element" warning but is needed — removing it produces an in-place diff.
- **Backblaze B2** (`backblaze/b2`): `flipenergy-homelab-truenas-backup` bucket (SSE-B2 encryption) + app key for TrueNAS backups.
- **Oracle Cloud** (`hashicorp/oci`): the `terraform-state` object storage bucket that holds this repo's state, and a $1/month budget with an alert on any actual spend. The `vm-instance` module and network are kept but the VM is commented out, so `terraform plan` doesn't exercise them — expect fixes against newer oci provider versions if it's re-enabled.
- **HTTP** (`hashicorp/http`): only used to fetch the public IP; not declared in `versions.tf`, so it's implicitly sourced and only pinned by the lock file.

## Layout (`homelab/`)

| File | Purpose |
|---|---|
| `dns_records.tf` | DNS record maps (`locals`) and module calls per zone. A records point at the current public IP fetched from `icanhazip.com` at plan time. Add `proxied = false` to bypass Cloudflare proxy (e.g. WireGuard). |
| `main.tf` | Oracle and Backblaze module calls, `moved` blocks. |
| `providers.tf`, `variables.tf`, `versions.tf`, `outputs.tf` | Standard. `versions.tf` holds `required_version`; keep `homelab/mise.toml` in sync with it. |
| `cloudflare_dns/`, `backblaze/`, `oracle/` (+ `oracle/vm-instance/`) | Local modules. |
| `*.template` | Templates for the gitignored `terraform.tfvars` and `backend.tf`. |
| `Makefile` | `make get-b2-key`, `make get-cf-token` — read sensitive outputs from state via `terraform show -json`. |

## Secrets — important

- `homelab/terraform.tfvars` and `homelab/backend.tf` are **gitignored and may exist locally with real credentials** (the backend address is an Oracle pre-authenticated URL with write access to state). Never print, copy, or commit their contents; never inline them into tracked files.
- The OCI private key is read from `~/.ssh/oracle.pem` by default.
- Outputs `b2_app_key` and `cloudflare_dns_edit_token` are sensitive.

## Workflow

- Run from `homelab/` via mise (`mise exec -- terraform …`, Terraform isn't on PATH otherwise): `terraform init`, `terraform validate`, `terraform fmt -recursive`, `terraform plan`. `init`/`plan` use the local gitignored `backend.tf` and `terraform.tfvars` without needing to read them.
- `terraform apply` changes real DNS/cloud resources — only with explicit approval.
- CI (`terraform` pipeline in sibling `concourse-pipelines`) runs on push to `main` and every Friday: `init`, `validate`, `fmt -recursive -check -diff`, `plan -lock=false -detailed-exitcode`. **Unformatted code or any pending diff fails the job**, so run `terraform fmt -recursive` and expect apply to be done manually by the owner.
- Use `moved {}` blocks when refactoring resource addresses to avoid destroy/recreate.
- Renovate (`renovate.json`) bumps provider versions. Its branches are often many commits behind `main`, so a plan run directly on a Renovate branch can show unrelated destroys; to evaluate a bump, apply the PR's commit on top of `main` (`git cherry-pick --no-commit <sha>`) and plan that.
- Commit and push directly to `main` (no feature branches). Use the `gh` CLI for PRs; Renovate PRs are merged with merge commits.

## Cross-repo

- New public hostnames for apps in `k8s-homelab` need an entry in `pleasenoddos_a_records`.
