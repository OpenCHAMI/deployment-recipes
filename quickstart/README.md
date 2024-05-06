# OpenCHAMI Quickstart

## Dependencies

The OpenCHAMI services themselves are all containerized and tested running under `docker compose`.  It should be possible to run OpenCHAMI services on any system with docker installed.

This quickstart makes a few assumptions about the target operating system and is only tested on Rocky Linux 9.3 running on x86 processors.  Feel free to file bugs about other configurations, but we will prioritize support for systems that we can directly test at LANL.

### Assumptions

* Linux - The quickstart automation makes several assumptions about the behavior Unix tools and their operation under bash from Rocky Linux 9.3
* x86_64 - Some of the containers involved are built and tested for alternative operating systems and architectures, but the solution as a whole is only tested with x86 containers
* Dedicated System - The docker compose setup assumes that it can take control of several TCP ports and interact with the host network for DHCP and TFTP.  It is tested on a dedicated virtual machine
* Local Name Registration - The quickstart bootstraps a Certificate Authority and issues an SSL certificate with a predictable name.  For access, you will need to add that name/IP to /etc/hosts on all clients or make it resolvable through your site DNS

## Start Here

1. Clone the repository and switch to that directory
   ```bash
   git clone https://github.com/OpenCHAMI/deployment-recipes.git
   cd deployment-recipes/quickstart/
   ```
1. Create the secrets file and choose a name for your system.
   This also sets the system name for your certificates.  In our case, we'll call our system "foobar".  The full url will be https://foobar.openchami.cluster which you can set in /etc/hosts to make life easier for you later
   ```bash
   # Create the secrets in the .env file.  Do not share them with anyone. 
   ./generate-configs.sh foobar
   ```
   If you have problems with this step, check to make sure that the main IP address of your host is in 
1. Update your /etc/hosts to point your system name to your local ip (this is important for valid certs)
1. Start the main services
   ```bash 
   docker compose -f base.yml -f postgres.yml -f jwt-security.yml -f haproxy-api-gateway.yml -f  openchami-svcs.yml -f autocert.yml up -d
   ```
1. Use the running system to download your certs and create your access token(s)
   ```bash
   # Assuming you're using bash as your shell, you can use the included functions to simplify interactions with your new OpenCHAMI system.
   source bash_functions.sh
   # Download the root ca so you can validate the ssl certificates included with your system
   get_ca_cert > cacert.pem
   # Create a jwt access token for use with the apis.
   ACCESS_TOKEN=$(gen_access_token)
   # If you're curious about that token, you can safely copy and paste it into https://jwt.io to learn more.
   # Use curl to confirm that everything is working
   curl --cacert cacert.pem -H "Authorization: Bearer $ACCESS_TOKEN" https://foobar.openchami.cluster/hsm/v2/State/Components
   # This should respond with an empty set of Components: {"Components":[]}
   ```
1. Create a token that can be used by the dnsmasq-loader which reads from smd.  This activates our automatic dns/dhcp system.  The command automatically adds it to .env
   ```bash
    echo "DNSMASQ_ACCESS_TOKEN=$(gen_access_token)" >> .env
    ```
1. Use docker-compose to bring up your dnsmasq contianers.  The only difference between this command and the one above is the addition of the `dnsmasq.yml` file.  Docker compose needs to know about all the files to follow dependencies.
   ```bash
   docker compose -f base.yml -f postgres.yml -f jwt-security.yml -f haproxy-api-gateway.yml -f openchami-svcs.yml -f autocert.yml -f dnsmasq.yml up -d
   ```




## What's next?

### Refresh your certificates

This quickstart takes advantage of short lived certs and tokens.  To renew the certificate for your system, run these commands daily, perhaps with cron:

```bash
docker compose -f base.yml -f postgres.yml -f jwt-security.yml -f haproxy-api-gateway.yml -f openchami-svcs.yml -f autocert.yml -f dnsmasq.yml restart acme-register
sleep 5
docker compose -f base.yml -f postgres.yml -f jwt-security.yml -f haproxy-api-gateway.yml -f openchami-svcs.yml -f autocert.yml -f dnsmasq.yml restart acme-deploy
sleep 5
docker compose -f base.yml -f postgres.yml -f jwt-security.yml -f haproxy-api-gateway.yml -f openchami-svcs.yml -f autocert.yml -f dnsmasq.yml restart haproxy

```

## Helpful docker cheatsheet

This quickstart uses `docker compose` to start up services and define dependencies.  If you have a basic understanding of docker, you should be able to work with the included services.  Some handy items to remember for when you are exploring the deployment are below.


`docker volume list` This lists all the volumes.  If they exist, the project will try to reuse them.  That might not be what you want.
`docker network list` ditto for networks
`docker ps -a` the -a shows you containers that aren't running.  We have several containers that are designed to do their thing and then exit.
`docker logs <container-id>` allows you to check the logs of containers even after they have exited
`docker compose ... down --volumes` will not only bring down all the services, but also delete the volumes

## Going even further