# Deployment Recipe for use with Docker compose


1. `echo "POSTGRES_PASSWORD=$(openssl rand -base64 32)" > .env`
1. `echo "BSS_POSTGRES_PASSWORD=$(openssl rand -base64 32)" >> .env`
1. `docker compose -f ochami-services.yml -f ochami-krakend-ce.yml up`


### Note on ochami-init errors

Docker compose doesn't dispose of ephemeral volumes unless you run

`docker compose -f ochami-services.yml -f ochami-krakend-ce.yml -f hydra.yml down --volumes`

Try disposing of the volumes if you're seeing an error that looks something like this:

`ochami-init      | time="2024-01-23T17:58:49Z" level=fatal msg="pq: role \"smd-init-user\" already exists"`
`postgres         | 2024-01-23 17:58:49.664 UTC [26] ERROR:  role "smd-init-user" already exists`