#!/usr/bin/env bats

setup(){
    load test_helper
}

@test "Recursor answers to query over UDP" {
    run dig +notcp +short @${PDNS_HOST} -t TXT test.localhost
    [ "$status" -eq 0 ]
    [ "$output" = '"Result"' ]
}

@test "Recursor answers to query over TCP" {
    run dig +tcp +short @${PDNS_HOST} -t TXT test.localhost
    [ "$status" -eq 0 ]
    [ "$output" = '"Result"' ]
}

@test "Attempt to transfer zone fails" {
    result="$(dig +tcp @${PDNS_HOST} AXFR www.m4rcu5.nl | grep -c '; Transfer failed.')"
    [ "$result" -eq 1 ]
}

@test "Reload authorative and forwarded zones" {
    run docker exec ${DOCKER_CONTAINER_NAME} rec_control reload-zones
    [ "$status" -eq 0 ]
    [ "$output" = "ok" ]
}
