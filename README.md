# Lightweight pdns-recursor Docker image
[![Anchore Image Overview](https://anchore.io/service/badges/image/16fe22cef64d4c60f420e479aedea43bb5668bcb02302fea27391bf70057512c)](https://anchore.io/image/dockerhub/m4rcu5%2Fpdns-recursor%3Alatest) ![Docker Pulls](https://img.shields.io/docker/pulls/m4rcu5/pdns-recursor.svg) [![Build Status](https://travis-ci.org/m4rcu5nl/docker-pdns-recursor-alpine.svg?branch=master)](https://travis-ci.org/m4rcu5nl/docker-pdns-recursor-alpine) [![GitHub issues](https://img.shields.io/github/issues/m4rcu5nl/docker-pdns-recursor-alpine.svg)](https://github.com/m4rcu5nl/docker-pdns-recursor-alpine/issues)  

Docker image for PowerDNS Recursor 4.1.3. Super lightweight thanks to the Alpine Linux 3.8 base image. Total image size for the current build is **27.2MB**
- - -
## Getting the image
You can either clone this repo and build the image yourself or pull it from Docker Hub. The `:latest` tag on Docker Hub is a daily automated build.

```bash
# Example command to build an image
sudo docker image build -t pdns-recursor .

# Example command to pull an image
sudo docker image pull m4rcu5/pdns-recursor:latest
```
- - -
## Using the image

#### Default configuration
The recursor will work out of the box as long as you query it from a private network. To create a container without any additional configuration simply run:
```bash
docker container run \
    --detach \
    --hostname resolver.local \
    --name pdns-recursor \
    --mount type=bind,src=/etc/localtime,dst=/etc/localtime,readonly=true \
    m4rcu5/pdns-recursor:latest
```
Let's assume the container can be reached on `172.17.0.4`. You can now query it with dig for example:
```
dig +tcp @172.17.0.4 google.com

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

#### Custom configuration
It is possible to overwrite default settings by defining them in custom `.conf` files in `/data/recursor-conf.d/`. As an example this repo contains a zone file for the localhost zone and a configuration file to tell the recursor it has authority for that zone. Let's assume this repo has been cloned to `/opt` of the container host resulting in something similar to this:  

```
/opt
└── pdns-recursor
    └── data
        ├── recursor-conf.d
        │   └── auth-zones.conf
        ├── scripts
        └── zones
            └── localhost
```
Now this local folder can be mounted as a volume inside the container:  
```bash
docker container run \
    --detach \
    --hostname resolver.local \
    --name pdns-recursor \
    --mount type=bind,src=/etc/localtime,dst=/etc/localtime,readonly=true \
    --mount type=bind,src=/opt/pdns-recursor/data,dst=/data,readonly=true \
    m4rcu5/pdns-recursor:latest
```
Now the recursor will look in `/data/zones/localhost` whenever it receives a query for that zone.  

Let's say we also want the recursor to validate DNSSEC queries. This can be accomplished by creating a `.conf` file for it and restarting the container:
```bash
# Create the config file
echo 'dnssec=validate' > /opt/pdns-recursor/data/recursor-conf.d/dnssec.conf

# Restart the container
docker container restart pdns-recursor
```
A complete list of settings for the recursor can be found on [https://doc.powerdns.com/md/recursor/settings/](https://doc.powerdns.com/md/recursor/settings/)
