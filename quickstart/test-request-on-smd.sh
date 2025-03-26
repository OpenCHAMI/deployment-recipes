#!/bin/sh

for url in \
"/hsm/v2/service/liveness" \
"/hsm/v2/State/Components" \
"/hsm/v2/State/Components/Query" \
"/hsm/v2/Inventory/ComponentEndpoints" \
"/hsm/v2/locks/service/reservations/check" \
"/hsm/v2/locks/service/reservations" \
"/hsm/v2/locks/service/reservations/release" \
"/hsm/v2/sysinfo/powermaps"
do
  docker exec -it smd curl -s  -H "Authorization: Bearer $(<access_token)" "http://localhost:27779$url?id=x0c0r1"
done
