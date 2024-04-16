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
  -f autocert.yml \ 
  -f postgres.yml \
  -f jwt-security.yml \ 
  -f api-gateway.yml \ 
  -f openchami-svcs.yml \ 
up -d
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