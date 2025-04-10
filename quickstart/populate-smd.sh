#!/bin/sh

# populate like this [docker compose][1] do
# 1: https://github.com/OpenCHAMI/power-control/blob/main/docker-compose.test.ct.yaml#L108

curl -X POST -d '{"RedfishEndpoints":[{
  "ID":"x1000c0s0b3",
  "FQDN":"x1000c0s0b3",
  "RediscoverOnUpdate":true,
  "User":"root",
  "Password":"root_password"
}]}' http://localhost:27779/hsm/v2/Inventory/RedfishEndpoints
