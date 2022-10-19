resource "kubernetes_secret" "default_ingress_nginx_tls" {
  metadata {
    name      = "letsencrypt-tls"
    namespace = "default"
  }

  data = {
    "tls.crt" = var.cert
    "tls.key" = var.key
  }

  type = "kubernetes.io/tls"
}
