# Deployment Recipe for use with Docker compose


1. `echo "POSTGRES_PASSWORD=$(openssl rand -base64 32)" > .env`
1. `echo "BSS_POSTGRES_PASSWORD=$(openssl rand -base64 32)" >> .env`
1. `docker compose -f ochami-services.yml -f ochami-krakend-ce.yml up`
