# Several functions that have been useful to me in developing and testing the quickstart.
# They aren't necessary.  Just educational.

CURL_CONTAINER=cgr.dev/chainguard/curl
CURL_TAG=latest

get_eth0_ipv4() {
   local ipv4
    ipv4=$(ip -o -4 addr show eth0 | awk '{print $4}')
    echo "${ipv4%/*}"
}

get_ca_cert() {
    local ca_cert
    ${CONTAINER_CMD:-docker} exec -it step-ca step ca root
    echo "${ca_cert}"
}

container_curl() {
    local url=$1
    ${CONTAINER_CMD:-docker} run -it --rm "${CURL_CONTAINER}:${CURL_TAG}" -s $url
}

create_client_credentials() {
   ${CONTAINER_CMD:-docker} exec hydra hydra create client \
    --endpoint http://hydra:4445/ \
    --format json \
    --grant-type client_credentials \
    --scope openid \
    --scope smd.read 
}

# CLIENT_CREDENTIALS=$(create_client_credentials)
# $(echo $CLIENT_CREDENTIALS | jq -r '"\(.client_id):\(.client_secret)"')

retrieve_access_token() {
    local CLIENT_ID=$1
    local CLIENT_SECRET=$2

    ${CONTAINER_CMD:-docker} run --rm --network quickstart_jwt-internal "${CURL_CONTAINER}:${CURL_TAG}" -s -u "$CLIENT_ID:$CLIENT_SECRET" \
    -d grant_type=client_credentials \
    -d scope=openid+smd.read \
    http://hydra:4444/oauth2/token
}

# ACCESS_TOKEN=$(retrieve_access_token $CLIENT_ID $CLIENT_SECRET | jq -r .access_token)

gen_access_token() {
    local CLIENT_CREDENTIALS
    CLIENT_CREDENTIALS=$(create_client_credentials)
    local CLIENT_ID=`echo $CLIENT_CREDENTIALS | jq -r '.client_id'`
    local CLIENT_SECRET=`echo $CLIENT_CREDENTIALS | jq -r '.client_secret'`
    local ACCESS_TOKEN=$(retrieve_access_token $CLIENT_ID $CLIENT_SECRET | jq -r .access_token)
    echo $ACCESS_TOKEN
}
