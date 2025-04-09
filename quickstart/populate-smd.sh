#!/bin/sh

# populate like this [docker compose][1] do
# 1: https://github.com/OpenCHAMI/power-control/blob/main/docker-compose.test.ct.yaml#L108

curl -X POST -d '{"RedfishEndpoints":[{
  "ID":"x0c0b0",
  "FQDN":"x0c0b0",
  "RediscoverOnUpdate":true,
  "User":"root",
  "Password":"root_password"
},{
  "ID":"x0c0s0b0",
  "FQDN":"x0c0s0b0",
  "RediscoverOnUpdate":true,
  "User":"root",
  "Password":"root_password"
},{
  "ID":"x0c0s1b0",
  "FQDN":"x0c0s1b0",
  "RediscoverOnUpdate":true,
  "User":"root",
  "Password":"root_password"
},{
  "ID":"x0c0s2b0",
  "FQDN":"x0c0s2b0",
  "RediscoverOnUpdate":true,
  "User":"root",
  "Password":"root_password"
},{
  "ID":"x0c0s3b0",
  "FQDN":"x0c0s3b0",
  "RediscoverOnUpdate":true,
  "User":"root",
  "Password":"root_password"
},{
  "ID":"x0c0s4b0",
  "FQDN":"x0c0s4b0",
  "RediscoverOnUpdate":true,
  "User":"root",
  "Password":"root_password"
},{
  "ID":"x0c0s5b0",
  "FQDN":"x0c0s5b0",
  "RediscoverOnUpdate":true,
  "User":"root",
  "Password":"root_password"
},{
  "ID":"x0c0s6b0",
  "FQDN":"x0c0s6b0",
  "RediscoverOnUpdate":true,
  "User":"root",
  "Password":"root_password"
},{
  "ID":"x0c0s7b0",
  "FQDN":"x0c0s7b0",
  "RediscoverOnUpdate":true,
  "User":"root",
  "Password":"root_password"
}]}' http://localhost:27779/hsm/v2/Inventory/RedfishEndpoints
