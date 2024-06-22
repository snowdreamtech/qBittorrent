FROM snowdreamtech/alpine:3.20.0

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

ENV FLOOD_PORT=3000 \
    WEBUI_PORT=8080 \
    TORRENTING_PORT=6881 \
    WEBUI_USER="" \
    WEBUI_PASS="" \
    WEBUI_LANG="en" 

RUN apk add --no-cache qbittorrent-nox \
    python3 \
    openssl \
    nodejs \
    npm \
    && mkdir -p /var/lib/qBittorrent/bin/  \
    && mkdir -p /var/lib/qBittorrent/config/  \
    && mkdir -p /var/lib/qBittorrent/downloads/  \
    && mkdir -p /var/lib/qBittorrent/incomplete/  \
    && mkdir -p /var/lib/qBittorrent/torrents/  \
    && chown -R  qbittorrent:qbittorrent /var/lib/qBittorrent \
    && rm -rfv /var/lib/qbittorrent \
    && npm install --global flood

COPY config /var/lib/qBittorrent/config

COPY bin /var/lib/qBittorrent/bin

EXPOSE 3000 8080 6881/tcp 6881/udp

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]