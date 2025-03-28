#!/bin/sh

docker volume rm \
$( \
docker volume ls \
--format "{{.Name}}" \
--filter "name=quickstart"\
)
