ochami \
	--token $(<access_token) \
	--cacert cacert.pem \
	bss boot params get | jq
