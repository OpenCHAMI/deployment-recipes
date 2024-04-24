# OpenCHAMI Quickstart

## Dependencies

The OpenCHAMI services themselves are all containerized and tested running under `docker compose`.  It should be possible to run OpenCHAMI services on any system with docker installed.

This quickstart makes a few assumptions about the target operating system and is only tested on Rocky Linux 9.3 running on x86 processors.  Feel free to file bugs about other configurations, but we will prioritize support for systems that we can directly test at LANL.

### Assumption

* Linux - The quickstart automation makes several assumptions about the behavior Unix tools and their operation under bash from Rocky Linux 9.3
* x86_64 - Some of the containers involved are built and tested for alternative operating systems and architectures, but the solution as a whole is only tested with x86 containers
* Dedicated System - The docker compose setup assumes that it can take control of several TCP ports and interact with the host network for DHCP and TFTP.  It is tested on a dedicated virtual machine
* Local Name Registration - The quickstart bootstraps a Certificate Authority and issues an SSL certificate with a predictable name.  For access, you will need to add that name/IP to /etc/hosts on all clients or make it resolvable through your site DNS

## Start Here

```
# Clone the repository
git clone https://github.com/OpenCHAMI/deployment-recipes.git
# Enter the quickstart directory
cd deployment-recipes/quickstart/
# Create the secrets in the .env file.  Do not share them with anyone. 
# This also sets the system name for your certificates.  In our case, we'll call our system "foobar".  The full url will be https://foobar.openchami.cluster which you can set in /etc/hosts to make life easier for you later
./generate-configs.sh foobar
# Start the services
docker compose -f base.yml -f postgres.yml -f jwt-security.yml -f haproxy-api-gateway.yml -f openchami-svcs.yml -f autocert.yml up -d
# This shouldn't take too long.  A minute or two depending on how long pulling containers takes.
# Once you get the prompt back, you can download the public certificate from your ca.
docker exec -it step-ca step ca root > cacert.pem
# Use curl to confirm that everything is working
 curl --cacert cacert.pem https://foobar.openchami.cluster/login
```

## What's next?

## Helpful docker cheatsheet

This quickstart uses `docker compose` to start up services and define dependencies.  If you have a basic understanding of docker, you should be able to work with the included services.  Some handy items to remember for when you are exploring the deployment are below.


`docker volume list` This lists all the volumes.  If they exist, the project will try to reuse them.  That might not be what you want.
`docker network list` ditto for networks
`docker ps -a` the -a shows you containers that aren't running.  We have several containers that are designed to do their thing and then exit.
`docker logs <container-id>` allows you to check the logs of containers even after they have exited
`docker compose ... down --volumes` will not only bring down all the services, but also delete the volumes

## Going even further