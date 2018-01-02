FROM alpine:3.6
LABEL maintainer="Marcus Meurs <mail@m4rcu5.nl>" \
      version="0.1.1"

# Add community repo and install packages
RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/v3.6/community" >> /etc/apk/repositories && \
    echo "@main http://dl-cdn.alpinelinux.org/alpine/v3.6/main" >> /etc/apk/repositories && \
    apk add -U --no-cache \
    pdns-recursor@community \
    drill@main && \
    rm -rf /var/cache/apk/*

# Create directory for custom configuration files
RUN mkdir -p /data/recursor-conf.d

# Give ownership of default config file to recursor:recursor
# This enables runtime zone/config reloading with rec_control
RUN chown recursor: /etc/pdns/recursor.conf

# Edit recursor.conf
RUN sed -i "s|daemon=yes|daemon=no|g" /etc/pdns/recursor.conf && \
    sed -i "s|local-port=5353|local-port=53|g" /etc/pdns/recursor.conf && \
    sed -i "s|# local-address=127.0.0.1|local-address=0.0.0.0|g" /etc/pdns/recursor.conf && \
    sed -i "s|# include-dir=|include-dir=/data/recursor-conf.d|g" /etc/pdns/recursor.conf

# Make data dir a volume
VOLUME /data

# Heath check
# For this check to succeed the recursor needs authority over the localhost zone and the zone
# needs to have a TXT record for test.localhost with a value of "Result" ()
HEALTHCHECK --interval=5s --timeout=3s CMD drill TXT test.localhost @localhost | grep -q -s "Result"

# Run pdns_recursor
ENTRYPOINT ["/usr/sbin/pdns_recursor"]
