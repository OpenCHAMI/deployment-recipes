scp -r coredhcp admin:/root
docker \
	-H ssh://admin \
	run --rm \
	--name openchami-dhcp \
	--net=host \
	-d \
	-v /root/coredhcp:/etc/coredhcp:ro \
	-v openchami-quickstart-step-root-ca:/root_ca:ro \
	ghcr.io/openchami/coresmd:latest
