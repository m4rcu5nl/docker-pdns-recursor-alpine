#!/usr/bin/env bats

setup(){
    load test_helper
}

@test "Docker image is present" {
    #DOCKER_IMAGE_NAME="m4rcu5/pdns-recursor"
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
