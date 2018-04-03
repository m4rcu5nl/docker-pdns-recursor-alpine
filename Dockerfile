FROM alpine:3.7
LABEL maintainer="Marcus Meurs <mail@m4rcu5.nl>" \
      version="0.1.3"

# Add community repo and install packages
RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/v3.7/community" >> /etc/apk/repositories && \
    echo "@main http://dl-cdn.alpinelinux.org/alpine/v3.7/main" >> /etc/apk/repositories && \
    apk add -U --no-cache \
    pdns-recursor@community \
    drill@main && \
    rm -rf /var/cache/apk/*

# Edit recursor.conf
RUN sed -i "s|daemon=yes|daemon=no|g" /etc/pdns/recursor.conf && \
    sed -i "s|local-port=5353|local-port=53|g" /etc/pdns/recursor.conf && \
    sed -i "s|# local-address=127.0.0.1|local-address=0.0.0.0|g" /etc/pdns/recursor.conf && \
    sed -i "s|# include-dir=|include-dir=/data/recursor-conf.d|g" /etc/pdns/recursor.conf

# Give ownership of default config file to recursor:recursor
# This enables runtime zone/config reloading with rec_control
RUN chown recursor: /etc/pdns/recursor.conf

# Create directories for custom configuration files and authoritative zone files
RUN mkdir -p /data/recursor-conf.d /data/zones

# Deploy authoritative zone file for localhost
COPY data/zones/localhost /data/zones/

# Deploy config file totake authority over localhost zone
COPY data/recursor-conf.d/auth-zones.conf /data/recursor-conf.d/

# Make data dir a volume
VOLUME /data

# Heath check
#
# Note: I'm not testing actual recursion to determine the container health since this can fail due to
# configuration choices made on the host running the container.
#
# For this check to succeed the recursor needs authority over the localhost zone and the zone
# needs to have a TXT record for test.localhost with a value of "Result"
# Make sure you keep meeting these requirements when you mount custom config files in your container
# or provide a custom health check in your `docker run` command
HEALTHCHECK --interval=5s --timeout=3s CMD drill TXT test.localhost @localhost | grep -q -s "Result"

# Run pdns_recursor
ENTRYPOINT ["/usr/sbin/pdns_recursor"]
