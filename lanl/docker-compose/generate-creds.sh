#!/bin/bash

# Set DB passwords
echo "POSTGRES_PASSWORD=$(openssl rand -base64 32)" > .env
echo "BSS_POSTGRES_PASSWORD=$(openssl rand -base64 32)" >> .env
echo "SMD_POSTGRES_PASSWORD=$(openssl rand -base64 32)" >> .env
echo "HYDRA_POSTGRES_PASSWORD=hydra" >> .env
echo "KRATOS_POSTGRES_PASSWORD=kratos" >> .env
