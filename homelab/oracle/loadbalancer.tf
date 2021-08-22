locals {
  lb_ingress_routes = {
    "ok8s-https-1" : {
      port       = 80
      ip_address = module.ok8s_arm_node_1.private_ip
    },
    "ok8s-https-2" : {
      port       = 80
      ip_address = module.ok8s_arm_node_2.private_ip
    }
  }
}

resource "oci_core_public_ip" "homelab_lb_public_ip" {
  display_name   = "Homelab LB"
  compartment_id = var.tenancy_ocid
  lifetime       = "RESERVED"

  lifecycle {
    ignore_changes = [private_ip_id]
  }
}

resource "oci_load_balancer_load_balancer" "homelab_flex_lb" {
  display_name   = "Homelab Flex LB"
  shape          = "flexible"
  compartment_id = var.tenancy_ocid
  subnet_ids     = [oci_core_subnet.k8s_subnet.id]
  reserved_ips {
    id = oci_core_public_ip.homelab_lb_public_ip.id
  }
  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }
}

resource "oci_load_balancer_certificate" "homelab_lb_cert" {
  load_balancer_id   = oci_load_balancer_load_balancer.homelab_flex_lb.id
  ca_certificate     = var.cert_issuer_pem
  certificate_name   = "letsencrypt"
  private_key        = var.cert_priv_key
  public_certificate = var.cert_pem

  lifecycle {
    create_before_destroy = true
  }
}

resource "oci_load_balancer_backend_set" "homelab_lb_set" {
  name             = "https-backend-set"
  load_balancer_id = oci_load_balancer_load_balancer.homelab_flex_lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    interval_ms         = 30000
    port                = 80
    protocol            = "TCP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

resource "oci_load_balancer_listener" "homelab_lb_listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.homelab_flex_lb.id
  name                     = "https-listener"
  default_backend_set_name = oci_load_balancer_backend_set.homelab_lb_set.name
  port                     = 443
  protocol                 = "TCP"

  connection_configuration {
    idle_timeout_in_seconds = 3600
  }

  ssl_configuration {
    certificate_name        = oci_load_balancer_certificate.homelab_lb_cert.certificate_name
    verify_peer_certificate = false
  }
}

resource "oci_load_balancer_backend" "homelab_lb_backend" {
  for_each         = local.lb_ingress_routes
  load_balancer_id = oci_load_balancer_load_balancer.homelab_flex_lb.id
  backendset_name  = oci_load_balancer_backend_set.homelab_lb_set.name
  ip_address       = each.value.ip_address
  port             = each.value.port
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}
