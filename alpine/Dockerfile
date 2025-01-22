FROM snowdreamtech/golang:1.23.4-alpine3.21 AS builder

ENV QBT_PW_GEN_VERSION=1.0.2

RUN wget https://github.com/saltydk/qbt_pw_gen/archive/refs/tags/v${QBT_PW_GEN_VERSION}.tar.gz \ 
    && tar zxvf v${QBT_PW_GEN_VERSION}.tar.gz \ 
    && cd qbt_pw_gen-${QBT_PW_GEN_VERSION} \ 
    && go build -o passwd \
    && cp passwd ../



FROM snowdreamtech/node:18.20.1-alpine3.21

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="qBittorrent Image Based On Alpine" \
    org.opencontainers.image.description="Docker Images for qBittorrent on Alpine. (i386, amd64, arm32v6, arm32v7, arm64, ppc64le,riscv64, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/qbittorrent" \
    org.opencontainers.image.base.name="snowdreamtech/qbittorrent:alpine" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/qbittorrent" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="5.0.2" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/qbittorrent"

# Switch to the user
USER root

# Set the workdir
WORKDIR /root

# keep the docker container running
ENV KEEPALIVE=1 \
    # The cap_net_bind_service capability in Linux allows a process to bind a socket to Internet domain privileged ports, 
    # which are port numbers less than 1024. 
    CAP_NET_BIND_SERVICE=0 

ENV QBITTORRENT_VERSION=5.0.2-r0 \
    PEER_PORT=25413 \
    WEBUI_PORT=8080 \
    WEBUI_USER="" \
    WEBUI_PASS="" \
    WEBUI_LANG="en" 

ENV FLOOD_AUTH=none \
    FLOOD_PORT=3000 

ARG GID=1001 \
    UID=1001  \
    USER=qbittorrent \
    WORKDIR=/var/lib/qBittorrent

# Create a user with UID and GID
RUN if [ "${USER}" != "root" ]; then \
    addgroup -g ${GID} ${USER}; \
    adduser -h ${WORKDIR} -u ${UID} -g ${USER} -G ${USER} -s /bin/sh -D ${USER}; \
    # sed -i "/%sudo/c ${USER} ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers; \
    fi

# Enable CAP_NET_BIND_SERVICE
RUN if [ "${USER}" != "root" ] && [ "${CAP_NET_BIND_SERVICE}" -eq 1 ]; then \
    apk add --no-cache libcap; \
    # setcap 'cap_net_bind_service=+ep' `which nginx`; \
    fi

RUN apk add --no-cache \
    qbittorrent-nox=${QBITTORRENT_VERSION} \
    && mkdir -p /var/lib/qBittorrent/bin/ \
    && mkdir -p /var/lib/qBittorrent/cache/ \
    && mkdir -p /var/lib/qBittorrent/config/ \
    && mkdir -p /var/lib/qBittorrent/data/ \
    && mkdir -p /var/lib/qBittorrent/downloads/ \
    && mkdir -p /var/lib/qBittorrent/incomplete/ \
    && mkdir -p /var/lib/qBittorrent/logs/ \
    && mkdir -p /var/lib/qBittorrent/torrents/ \
    && rm -rfv /var/lib/qbittorrent \
    && find / -name "*qBittorrent*" -exec chown -Rv ${USER}:${USER} {} \; 

COPY --chown=${USER}:${USER} config /var/lib/qBittorrent/config

COPY --chown=${USER}:${USER} --from=builder /home/go/passwd /var/lib/qBittorrent/bin

RUN npm install --global flood

# Switch to the user
USER ${USER}

# Set the workdir
WORKDIR ${WORKDIR}

EXPOSE  3000 8080 25413/tcp 25413/udp

COPY --chown=${USER}:${USER} docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]