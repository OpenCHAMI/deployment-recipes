# Deployment Recipe for use with Docker compose

## Deployment Files

- `services.yml`: The main deployment file. Runs SMD and BSS with JWT
  authentication enabled, plus dnsmasq for handling DHCP requests from nodes.  
- `services-noauth.yml`: Like `ochami-services.yml`, but runs SMD and BSS
  with JWT authentication disabled.
- `ochami-hurl-tests.yml`: Runs integration tests using Hurl against the
  authentication-enabled BSS and SMD in `ochami-services.yml`.
- `ochami-hurl-tests-noauth.yml`: Runs integration tests using Hurl against the
  authentication-disabled BSS and SMD in `ochami-services-noauth.yml`.
- `opaal.yml`: Runs the OPAAL OIDC login helper tool. BSS requests a token from
  OPAAL, which then reaches out to Hydra to verify the client. This file is a
  dependency of `ochami-services.yml`.
- `krakend-ce.yml`: Runs the Krakend-CE API gateway for SMD and BSS.
- `hydra.yml`: Runs the Hydra OAuth2/OIDC server used for authentication-enabled
  BSS and SMD. This file is a dependency of `ochami-services.yml`.

## Running Deployments

1. Run the `generate-configs.sh` script to generate a `.env` file for use with `docker compose`.  It will be populated with randomly-generated passwords for each postgres database.  The script also copies the passwords into an OpenCHAMI configuration file that will be created by default in the local `configs/` directory.

**NOTE** These instructions include an environment variable that ensures the use of linux/amd64 containers as those are the only form built and tested by default.  This should work on any Linux machine and even on new ARM-based computers from Apple.

   To run the services:
   ```
   DOCKER_DEFAULT_PLATFORM=linux/amd64 docker compose \
-f postgres.yml \
-f services.yml \
-f opaal.yml \
-f hydra.yml \
-f krakend-ce.yml
   ```

1. After a minute or so you can check the health of SMD:

   ```
   curl http://<smd_host>:27779/hsm/v2/service/ready
   ```

   Remember to use `<smd_host>:37779` if using unauthenticated SMD.
1. And BSS:

   ```
   curl http://<bss_host>:27778/boot/v1/service/status
   ```

   Remember to use `<bss_host>:37778` if using unauthenticated BSS.

## Running Integration Tests

The integration tests use [Hurl](https://hurl.dev/) to send API calls to SMD and
BSS to perform integration testing. Because there are both authenticated and
unauthenticated versions of SMD and BSS, there are also authenticated and
unauthenticated versions of the integration tests.

To run the authenticated integration tests:

```
docker compose -f ochami-services.yml -f ochami-hurl-tests.yml -f hydra.yml up
```

To run the unauthenticated integration tests:

```
docker compose -f ochami-services-noauth.yml -f ochami-hurl-tests-noauth.yml up
```

To run both the authenticated and unauthenticated integration tests:

```
docker compose
  -f ochami-services.yml \
  -f ochami-services-noauth.yml \
  -f ochami-hurl-tests.yml \
  -f ochami-hurl-tests-noauth.yml \
  -f hydra.yml \
  up
```

## Note on ochami-init errors

Docker compose doesn't dispose of ephemeral volumes unless you run

```
docker compose -f ochami-services.yml -f ochami-krakend-ce.yml -f hydra.yml down --volumes
```

Try disposing of the volumes if you're seeing an error that looks something like
this:

```
ochami-init      | time="2024-01-23T17:58:49Z" level=fatal msg="pq: role \"smd-init-user\" already exists"
postgres         | 2024-01-23 17:58:49.664 UTC [26] ERROR:  role "smd-init-user" already exists
```
