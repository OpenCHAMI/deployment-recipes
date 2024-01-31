#!/bin/bash

# Set DB passwords
echo "POSTGRES_PASSWORD=$(openssl rand -base64 32 | sha1sum | awk '{print $1}')" > .env
echo "BSS_POSTGRES_PASSWORD=$(openssl rand -base64 32 | sha1sum | awk '{print $1}')" >> .env
echo "SMD_POSTGRES_PASSWORD=$(openssl rand -base64 32 | sha1sum | awk '{print $1}')" >> .env
echo "HYDRA_POSTGRES_PASSWORD=$(openssl rand -base64 32 | sha1sum | awk '{print $1}')" >> .env
