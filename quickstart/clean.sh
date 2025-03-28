#!/bin/sh

rm -rf keys

docker volume rm \
$( \
docker volume ls \
--format "{{.Name}}" \
--filter "name=quickstart"\
)
