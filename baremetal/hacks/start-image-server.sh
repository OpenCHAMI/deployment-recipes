ssh -t admin 'mkdir -p disk-images'
docker -H ssh://admin \
	run --name image-server \
	--rm \
	-d -p 80:8080 \
	-v "/root/disk-images:/usr/share/nginx/html" \
	nginxinc/nginx-unprivileged
