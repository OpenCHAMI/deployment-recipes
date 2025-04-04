#!/bin/sh

rm -rf keys

VOLUME=$(docker volume ls --format "{{.Name}}" --filter "name=quickstart")

if [[ -z VOLUME ]]; then docker volume rm $VOLUME; fi
