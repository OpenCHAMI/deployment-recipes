#!/bin/sh

KEYS_PATH="keys"

create_keys() {
	(
	cd "${KEYS_PATH}"
	openssl genrsa -out private_key.pem 2048
	openssl rsa -in private_key.pem -outform PEM -pubout -out public_key.pem
	)
}

create_token() {
	(
	cd "${KEYS_PATH}"
	cipher="RS256"
	pub_key="private_key.pem"

	header="$(cat <<-EOF
	{
	  "alg": "$cipher",
	  "typ": "JWT",
	  "kid": "$kid"
	}
	EOF
	)"

	payload="$(cat <<-EOF
	{
	  "aud": "test",
	  "name": "John Doe",
	  "iat" : $(date +%s),
	  "exp": $(date +%s --date tomorrow),
	  "sub": "sub"
	}
	EOF
	)"

	header=$(jq -c -r . <<< "$header")

	header=$(echo -n "$header" | \
		openssl enc -base64 \
		| tr -d '=' | tr '/+' '_-' | tr -d '\n' )

	payload=$(jq -c -r . <<< "$payload" 2>&1);

	payload=$(echo -n "$payload" | \
		openssl enc -base64 | \
		tr -d '=' | tr '/+' '_-' | tr -d '\n' )

	signature="$(echo -n "${header}.${payload}" | \
		openssl dgst -sha256 -binary -sign ${pub_key} | \
		openssl enc -base64 | \
		tr -d '=' | tr '/+' '_-' | tr -d '\n' )"

	echo "${header}.${payload}.$signature" > token
	)
}

create_role() {
	echo "test-role" > "${KEYS_PATH}"/role
}

main() {
	mkdir -p "${KEYS_PATH}"
	create_keys
	create_token
	create_role
}

main
