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
  subnet_ids = [oci_core_subnet.homelab_subnet.id]
  reserved_ips {
    id = oci_core_public_ip.homelab_lb_public_ip.id
  }
  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }
}

resource "oci_load_balancer_backend_set" "homelab_lb_set" {
  name             = "homelab-flex-lb-backend-set"
  load_balancer_id = oci_load_balancer_load_balancer.homelab_flex_lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "6443"
    protocol            = "TCP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

resource "oci_load_balancer_listener" "homelab_lb_listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.homelab_flex_lb.id
  name                     = "homelab-6443-listener"
  default_backend_set_name = oci_load_balancer_backend_set.homelab_lb_set.name
  port                     = 6443
  protocol                 = "TCP"

  connection_configuration {
    idle_timeout_in_seconds            = "2"
    backend_tcp_proxy_protocol_version = "1"
  }
}

resource "oci_load_balancer_backend" "homelab_lb_backend" {
  for_each = toset([
    module.ok8s_amd_node_1.private_ip,
    module.ok8s_amd_node_2.private_ip,
    module.ok8s_arm_node_1.private_ip
  ])
  load_balancer_id = oci_load_balancer_load_balancer.homelab_flex_lb.id
  backendset_name  = oci_load_balancer_backend_set.homelab_lb_set.name
  ip_address       = each.value
  port             = 6443
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}
