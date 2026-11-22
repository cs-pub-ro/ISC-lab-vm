FROM debian:bookworm-slim

# keep apt from trying to talk to systemd during the build
RUN printf '#!/bin/sh\nexit 101\n' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d

RUN apt-get update \
 && apt-get install -y --no-install-recommends bind9 \
 && rm -rf /var/lib/apt/lists/*

COPY named.conf /etc/bind/named.conf
COPY db.isc.lab /etc/bind/db.isc.lab

EXPOSE 53/tcp
EXPOSE 53/udp
CMD ["named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]
