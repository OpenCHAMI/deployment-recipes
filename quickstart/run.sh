#!/bin/sh

until docker-compose \
  -f base.yml \
  -f postgres.yml \
  -f jwt-security.yml \
  -f haproxy-api-gateway.yml \
  -f  openchami-svcs.yml \
  -f autocert.yml \
  -f coredhcp.yml \
  -f pcs.yml \
  -f vault.yml \
  -f etcd.yml \
  -f configurator.yml up -d
do
docker-compose \
  -f base.yml \
  -f postgres.yml \
  -f jwt-security.yml \
  -f haproxy-api-gateway.yml \
  -f  openchami-svcs.yml \
  -f autocert.yml \
  -f coredhcp.yml \
  -f pcs.yml \
  -f vault.yml \
  -f etcd.yml \
  -f configurator.yml down
done

source bash_functions.sh
gen_access_token > access_token
get_ca_cert > cacert.pem
