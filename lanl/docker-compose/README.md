# Deployment Recipe for use with Docker compose

1. Run `docker compose -f ochami-services.yml -f ochami-krakend-ce.yml up` to bring up ochami services
1. After a minute or so you can check the health of SMD: `curl http://<smd_host>:27779/hsm/v2/service/ready`
1. And BSS: `curl http://<bss_host>:27778/boot/v1/service/status`
1. Run the `generate-creds.sh` script to generate a `.env` file populated with randomly-generated passwords for each Postgres database. This file will be read by Docker Compose.

### Note on ochami-init errors

Docker compose doesn't dispose of ephemeral volumes unless you run

`docker compose -f ochami-services.yml -f ochami-krakend-ce.yml -f hydra.yml down --volumes`

Try disposing of the volumes if you're seeing an error that looks something like this:

`ochami-init      | time="2024-01-23T17:58:49Z" level=fatal msg="pq: role \"smd-init-user\" already exists"`
`postgres         | 2024-01-23 17:58:49.664 UTC [26] ERROR:  role "smd-init-user" already exists`
