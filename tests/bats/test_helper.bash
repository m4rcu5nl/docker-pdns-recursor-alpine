if [[ "${TRAVIS}" == "true" ]]; then
    export DOCKER_IMAGE_NAME="pdns_recursor"
    export DOCKER_CONTAINER_NAME="pdns_recursor"
else
    export DOCKER_IMAGE_NAME="m4rcu5/pdns-recursor"
    export DOCKER_CONTAINER_NAME="pdns-recursor"
fi

export PDNS_HOST="$(docker inspect ${DOCKER_CONTAINER_NAME} -f "{{.NetworkSettings.IPAddress}}")"
