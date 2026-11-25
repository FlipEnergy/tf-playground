locals {
  # Remotely managed tunnels have this DNS target; proxied CNAMEs to it route
  # traffic into the tunnel.
  tunnel_cname = "${cloudflare_zero_trust_tunnel_cloudflared.homelab.id}.cfargotunnel.com"

  # Merge into a DNS record entry to route it through the tunnel.
  via_tunnel = {
    type    = "CNAME"
    content = local.tunnel_cname
  }

  # Every record routed through the tunnel, as a full hostname.
  tunnel_hostnames = sort([
    for r in values(local.pleasenoddos_a_records) :
    r.name == local.pleasenoddos_root_domain ? r.name : "${r.name}.${local.pleasenoddos_root_domain}"
    if lookup(r, "type", "A") == "CNAME"
  ])

  # In-cluster ingress controller (k8s-homelab: traefik).
  tunnel_origin = "https://traefik.traefik.svc.cluster.local:443"
}

data "cloudflare_accounts" "homelab" {
  name = "Dennis Homelab"
}

# Remotely managed tunnel: its ingress rules live in Cloudflare (below) and
# cloudflared in k8s-homelab only needs the token.
resource "cloudflare_zero_trust_tunnel_cloudflared" "homelab" {
  account_id = data.cloudflare_accounts.homelab.result[0].id
  name       = "homelab"
  config_src = "cloudflare"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "homelab" {
  account_id = data.cloudflare_accounts.homelab.result[0].id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.homelab.id

  config = {
    origin_request = {
      # Send the requested hostname as SNI so the ingress controller serves that
      # host's Let's Encrypt cert, which cloudflared then verifies.
      match_sn_ito_host = true
    }

    ingress = concat(
      [for host in local.tunnel_hostnames : {
        hostname = host
        service  = local.tunnel_origin
      }],
      # Required catch-all.
      [{ service = "http_status:404" }],
    )
  }
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "homelab" {
  account_id = data.cloudflare_accounts.homelab.result[0].id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.homelab.id
}
