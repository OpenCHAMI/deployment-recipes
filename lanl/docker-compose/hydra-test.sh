#!/bin/bash

# This script is used to test Hydra with Docker Compose within an ochami deployment recipe

## Create the OAuth2 client

CLIENT=$(hydra create client \
    --endpoint http://127.0.0.1:4445/ \
    --format json \
    --grant-type client_credentials \
    )

## Extract the client ID and secret
CLIENT_ID=$(echo $CLIENT | jq -r '.client_id')
CLIENT_SECRET=$(echo $CLIENT | jq -r '.client_secret')

## Use the client credentials to get an access token

## Manually with curl
# curl -s -k -u "$client_id:$client_secret" -d grant_type=client_credentials -d scope=openid http://127.0.0.1:4444/oauth2/token

TOKEN=$(curl -s -k -u "$CLIENT_ID:$CLIENT_SECRET" \
    -d grant_type=client_credentials \
    -d scope=hydra.keys.get \
    https://127.0.0.1:4444/oauth2/token \
    )

