#!/bin/sh

echo "check the if pcs is running"

docker logs pcs 2>&1 | grep '**RUNNING -- Listening'
docker logs pcs 2>&1 | grep 'ETCD connection succeeded.'
