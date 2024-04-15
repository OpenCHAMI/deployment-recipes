# OpenCHAMI Quickstart

## Dependencies

The quickstart uses freely available components without external dependencies.  If you can run `docker compose`, it should work on your machine.

If you want to test with the same operating system and configuration we use at LANL, we've created a [Vagrantfile](https://gist.github.com/alexlovelltroy/1aa6d07119ef59fd966417c97baa2ff5) that provisions a VM based on [Rocky 9.3](https://app.vagrantup.com/generic/boxes/rocky9) with all the dependencies necessary for testing and development.


## Start Here


```
# Clone the repository
git clone git@github.com:OpenCHAMI/deployment-recipes.git
# Enter the quickstart directory
cd deployment-recipes/quickstart/
# Create the secrets.  Do not share them with anyone
./generate-configs.sh
# Start the services
docker compose \
-f autocert.yml \ # The 3rd-party open source automatic certificate management services
-f postgres.yml \ # The 3rd-party open source database server.  The only one used with OpenCHAMI
-f jwt-security.yml \ # The 3rd-party open source services necessary for using JWTs to authenticate and authorize
-f api-gateway.yml \ # The 3rd-party open source API Gateway that serves as a frontdoor for the rest of the services and integrates jwts and certs
-f openchami-svcs.yml \ # The custom services at the core of OpenCHAMI along with a heavily customized container for dnsmasq

```


## What's next?