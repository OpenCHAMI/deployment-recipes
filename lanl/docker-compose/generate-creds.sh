#!/bin/bash

# Set DB passwords
echo "POSTGRES_PASSWORD=$(openssl rand -base64 32 | openssl dgst | cut -d' ' -f2)" > .env
echo "BSS_POSTGRES_PASSWORD=$(openssl rand -base64 32 | openssl dgst | cut -d' ' -f2)" >> .env
echo "SMD_POSTGRES_PASSWORD=$(openssl rand -base64 32 | openssl dgst | cut -d' ' -f2)" >> .env
echo "HYDRA_POSTGRES_PASSWORD=$(openssl rand -base64 32 | openssl dgst | cut -d' ' -f2)" >> .env
