FROM snowdreamtech/golang:1.22.4 AS builder

ENV QBT_PW_GEN_VERSION=1.0.2

RUN mkdir /workspace
WORKDIR /workspace
RUN wget https://github.com/saltydk/qbt_pw_gen/archive/refs/tags/v${QBT_PW_GEN_VERSION}.tar.gz \ 
    && tar zxvf v${QBT_PW_GEN_VERSION}.tar.gz \ 
    && cd qbt_pw_gen-${QBT_PW_GEN_VERSION} \ 
    && go build -o passwd \
    && cp passwd ../



FROM snowdreamtech/alpine:3.20.2

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

ENV PEER_PORT=6881 \
    WEBUI_PORT=8080 \
    WEBUI_USER="admin" \
    WEBUI_PASS="" \
    WEBUI_LANG="en" 

RUN apk add --no-cache qbittorrent-nox=4.6.4-r1 \
    openssl \
    && mkdir -p /var/lib/qBittorrent/bin/ \
    && mkdir -p /var/lib/qBittorrent/config/ \
    && mkdir -p /var/lib/qBittorrent/downloads/ \
    && mkdir -p /var/lib/qBittorrent/incomplete/ \
    && mkdir -p /var/lib/qBittorrent/torrents/ \
    && chown -R  qbittorrent:qbittorrent /var/lib/qBittorrent \
    && rm -rfv /var/lib/qbittorrent  

COPY config /var/lib/qBittorrent/config

COPY --from=builder /workspace/passwd /var/lib/qBittorrent/bin

EXPOSE 8080 6881/tcp 6881/udp

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]