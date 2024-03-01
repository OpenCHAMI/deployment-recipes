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

echo "CLIENT_ID: $CLIENT_ID"
echo "CLIENT_SECRET: $CLIENT_SECRET"

## Use the client credentials to get an access token

## Manually with curl
# curl -s -k -u "$client_id:$client_secret" -d grant_type=client_credentials -d scope=openid http://127.0.0.1:4444/oauth2/token

TOKEN=$(curl -s -k -u "$CLIENT_ID:$CLIENT_SECRET" \
    -d grant_type=client_credentials \
    -d scope=openid \
    http://127.0.0.1:4444/oauth2/token \
    )
ACCESS_TOKEN=$(echo $TOKEN | jq -r '.access_token')
export ACCESS_TOKEN=$ACCESS_TOKEN

echo "TOKEN: $TOKEN"
echo "ACCESS_TOKEN: $ACCESS_TOKEN"

# make a request to the API gateway to SMD
#curl -s -k http://127.0.0.1:3000 -H 'alg: "RS256"' -H '"kid": "$TOKEN"'

# make a request directly to SMD
curl http://127.0.0.1:27779/hsm/v2/service/ready -H "Authorization: BEARER $ACCESS_TOKEN"

# make a request with a bad token
curl http://127.0.0.1:27779/hsm/v2/service/ready -H "Authorization: BEARER iamabadtoken"
