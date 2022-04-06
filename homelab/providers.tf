provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

provider "cloudflare" {
  email   = var.my_email
  api_key = var.cloudflare_api_key
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = var.oci_private_key_path
  fingerprint      = var.fingerprint
  region           = var.region
}

provider "b2" {
  application_key    = var.b2_app_key
  application_key_id = var.b2_key_id
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "homelab"
}
