get-certs-and-key:
	terraform show -json | jq -r '.values.outputs | [.certificate.value, .private_key.value]' | sed 's/\\n/\n/g'
