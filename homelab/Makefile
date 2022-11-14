get-b2-key:
	terraform show -json | jq -r '.values.outputs.b2_app_key.value'

update-cert:
	terraform apply -target module.letsencrypt.acme_certificate.cert -target module.homelab_k8s.kubernetes_secret.default_ingress_nginx_tls -target module.oracle_k8s.kubernetes_secret.default_ingress_nginx_tls
