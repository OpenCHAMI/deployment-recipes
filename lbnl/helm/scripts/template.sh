#!/bin/bash

repo="$1"

helm template \
  ochami \
  . \
  -n ochami \
  --set bss.deployment.image.repository="${repo}" \
  --set init.job.image.repository="${repo}" \
  --set smd.deployment.image.repository="${repo}" \
  --set postgres.deployment.image.repository="${repo}" \
  --set dnsmasq.deployment.image.repository="${repo}" \
  --set hydra.deployment.image.repository="${repo}" \
  --set hydra_consent.deployment.image.repository="${repo}" \
  --set swiss_army_knife.deployment.image.repository="${repo}" \
  --set lighttpd.deployment.image.repository="${repo}" \
  --set tftpd.deployment.image.repository="${repo}" \
