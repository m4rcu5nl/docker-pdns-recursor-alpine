FROM alpine:3.5
LABEL maintainer="Marcus Meurs <mail@m4rcu5.nl>" \
      version="0.1.0"

# Add community repo and install packages
RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/v3.5/community" >> /etc/apk/repositories && \
    echo "@main http://dl-cdn.alpinelinux.org/alpine/v3.5/main" >> /etc/apk/repositories && \
    apk add -U --no-cache \
    pdns-recursor@community && \
    rm -rf /var/cache/apk/* && \

    # Create directory for custom configuration files
    mkdir -p /data/recursor-conf.d && \

    # Give ownership of default config file to recursor:recursor
    # This enables runtime zone/config reloading with rec_control
    chown recursor: /etc/pdns/recursor.conf && \

    # Prevent the recursor from running as a daemon
    sed -i "s|daemon=yes|daemon=no|g" /etc/pdns/recursor.conf && \

    # Make the recursor listen on local port 53
    sed -i "s|local-port=5353|local-port=53|g" /etc/pdns/recursor.conf && \

    # Make the recursor listen on 0.0.0.0 inside it's container
    sed -i "s|# local-address=127.0.0.1|local-address=0.0.0.0|g" /etc/pdns/recursor.conf && \

    # Configure include-dir for custom config files
    sed -i "s|# include-dir=|include-dir=/data/recursor-conf.d|g" /etc/pdns/recursor.conf

# Make data dir a volume
VOLUME /data

# Run pdns_recursor
ENTRYPOINT ["/usr/sbin/pdns_recursor"]
