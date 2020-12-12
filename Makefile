plan:
	terraform plan -out output  -var "do_token=${DO_PAT}" \
		-var "pvt_key=${KEY_PATH}" \
		-var "ssh_fingerprint=${FINGERPRINT_ID}" \
		-var "bastion_host_id=${BASTION_ID}" \
		-var "server_count=${SERVER_COUNT}" \
		-var "client_count=${CLIENT_COUNT}" 

apply:
	terraform apply output
