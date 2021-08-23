get-certs-and-key:
	terraform show -json | jq -r '.values.outputs.private_key.value' | sed 's/\\n/\n/g' > ~/.letsencrypt_private_key.pem
	terraform show -json | jq -r '.values.outputs.certificate_chain.value' | sed 's/\\n/\n/g' > ~/.letsencrypt_ca_chain.pem
