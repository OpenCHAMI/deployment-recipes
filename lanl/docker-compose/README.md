# Deployment Recipe for use with Docker compose


1. `echo "POSTGRES_PASSWORD=$(openssl rand -base64 32)" > .env`
1. `echo "BSS_POSTGRES_PASSWORD=$(openssl rand -base64 32)" >> .env`
1. `docker compose -f ochami-services.yml -f ochami-krakend-ce.yml up`

Keep in mind that docker compose doesn't dispose of ephemeral volumes unless you run

`docker compose -f ochami-services.yml -f ochami-krakend-ce.yml -f hydra.yml down --volumes`
