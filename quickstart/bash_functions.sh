# Several functions that have been useful to me in developing and testing the quickstart.
# They aren't necessary.  Just educational.


get_eth0_ipv4() {
   local ipv4
    ipv4=$(ip -o -4 addr show eth0 | awk '{print $4}')
    echo "${ipv4%/*}"
}

get_ca_cert() {
    local ca_cert
    docker exec -it step-ca step ca root
    echo "${ca_cert}"
}

container_curl() {
    local url=$1
    docker exec -it quay.io/curl/curl -s $url
}

create_client_credentials() {
   docker exec hydra hydra create client \
    --endpoint http://hydra:4445/ \
    --format json \
    --grant-type client_credentials
}
# $(echo $CLIENT_TOKEN | jq -r '"\(.client_id):\(.client_secret)"')

retrieve_access_token() {
    local CLIENT_ID=$1
    local CLIENT_SECRET=$2

    docker run --network quickstart_jwt-internal quay.io/curl/curl:latest curl -s -u "$CLIENT_ID:$CLIENT_SECRET" \
    -d grant_type=client_credentials \
    -d scope=openid \
    -d scope=smd.read \
    http://hydra:4444/oauth2/token
}

# ACCESS_TOKEN=$(retrieve_access_token $CLIENT_ID $CLIENT_SECRET | jq -r .access_token)