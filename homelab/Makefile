get-certs-and-key:
	terraform show -json | jq -r '.values.outputs.private_key.value' | base64 -w 0 > ~/.letsencrypt_private_key
	terraform show -json | jq -r '.values.outputs.certificate_chain.value' | base64 -w 0 > ~/.letsencrypt_ca_chain

get-b2-key:
	terraform show -json | jq -r '.values.outputs.b2_app_key.value'
