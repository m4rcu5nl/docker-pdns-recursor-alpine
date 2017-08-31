FROM alpine:3.5
LABEL maintainer="Marcus Meurs <mail@m4rcu5.nl>" \
      version="0.1.0.alpha"

# Add community repo and install packages
RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/v3.5/community" >> /etc/apk/repositories && \
    echo "@main http://dl-cdn.alpinelinux.org/alpine/v3.5/main" >> /etc/apk/repositories && \
    apk add -U --no-cache \
    pdns-recursor@community && \
    rm -rf /var/cache/apk/*

# Run pdns_recursor in foreground and listen on container's eth0 inet addr
ENTRYPOINT /usr/sbin/pdns_recursor --local-address=`awk 'END{print $1}' /etc/hosts`:53 --daemon=no
