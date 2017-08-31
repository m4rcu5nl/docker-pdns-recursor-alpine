[![Build Status](https://travis-ci.org/m4rcu5nl/docker-pdns-recursor-alpine.svg?branch=master)](https://travis-ci.org/m4rcu5nl/docker-pdns-recursor-alpine) [![GitHub issues](https://img.shields.io/github/issues/m4rcu5nl/docker-pdns-recursor-alpine.svg)](https://github.com/m4rcu5nl/docker-pdns-recursor-alpine/issues)  
docker-pdns-recursor-alpine
===========================
Docker image for PowerDNS Recursor 4.0.4 on Alpine Linux 3.5  
  
**WARNING:** Very early build

Build
-----
```
docker build -t whatchamacallit .
```
Run
---
```
docker run -d --name pdns_recursor whatchamacallit:latest
```
The above spawns a detached container named *pdns_recursor*. It listens on it's own eth0 inet address on port 53. Once you get it's IP-address you can query it from your host system.  
  
Example:
```
dig +tcp google.com @172.17.0.4

; <<>> DiG 9.10.3-P4-Ubuntu <<>> +tcp google.com @172.17.0.4
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 55033
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;google.com.            IN  A

;; ANSWER SECTION:
google.com.     300 IN  A   216.58.211.110

;; Query time: 37 msec
;; SERVER: 172.17.0.4#53(172.17.0.4)
;; WHEN: Thu Aug 31 23:35:44 CEST 2017
;; MSG SIZE  rcvd: 55
```
