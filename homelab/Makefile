output := b2_app_key

get-b2-key:
	terraform show -json | jq -r '.values.outputs.$(output).value'

get-cf-token: output := cloudflare_dns_edit_token
get-cf-token: get-b2-key
