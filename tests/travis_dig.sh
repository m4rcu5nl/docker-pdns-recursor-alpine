#!/bin/bash
DNSHOST="$(docker inspect pdns_recursor -f "{{.NetworkSettings.Networks.bridge.IPAddress}}")"
DIGRESULT="$(dig +short @${DNSHOST} -t TXT travis.localhost | tr -d "\"")"
test "${DIGRESULT}" = "Travis CI"
