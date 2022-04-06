resource "kubernetes_secret" "default_ingress_nginx_tls" {
  metadata {
    name = "letsencrypt-tls"
    namespace = "default"
  }

  data = {
    "tls.crt" = base64encode(var.cert)
    "tls.key" = base64encode(var.key)
  }

  type = "kubernetes.io/tls"
}
