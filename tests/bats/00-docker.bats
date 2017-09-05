#!/usr/bin/env bats

setup(){
    load test_helper
}

@test "Docker image is present" {
    result="$(docker images | grep -c "${DOCKER_IMAGE_NAME}")"
    [ "$result" -ge "1" ]
}

@test "Docker container is present" {
    result="$(docker ps -a | grep -c "${DOCKER_CONTAINER_NAME}")"
    [ "$result" -eq "1" ]
}

@test "Docker container is running" {
    result="$(docker ps | grep -c "${DOCKER_CONTAINER_NAME}")"
    [ "$result" -eq "1" ]
}

@test "Data mount is available to container" {
    result="$(docker inspect ${DOCKER_CONTAINER_NAME} -f "{{json .Mounts}}" | jq .[].Destination | grep 'data')"
    [ "$result" = '"/data"' ]
}

# https://hub.docker.com/r/library/alpine/tags/ shows vulnerability for 3.5 image
@test "Alpine linux version is version 3.6.x" {
    result="$(docker exec -ti ${DOCKER_CONTAINER_NAME} cat /etc/alpine-release | cut -d '.' -f 1,2)"
    [ "$result" = "3.6" ]
}
