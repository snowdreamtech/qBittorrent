FROM snowdreamtech/alpine:3.20.0

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

ENV WEBUI_PORT=8080 \
    TORRENTING_PORT=6881 \
    WEBUI_USER="snowdream" \
    WEBUI_PASS="ERnf9zM5f" \
    WEBUI_LANG="zh_CN" 

RUN apk add --no-cache qbittorrent-nox \
    openssl \
    && mkdir -p /var/lib/qBittorrent/config/  \
    && mkdir -p /var/lib/qBittorrent/downloads/  \
    && mkdir -p /var/lib/qBittorrent/incomplete/  \
    && mkdir -p /var/lib/qBittorrent/torrents/  \
    && chown -R  qbittorrent:qbittorrent /var/lib/qBittorrent

COPY config /var/lib/qBittorrent/config

EXPOSE 8080 6881/tcp 6881/udp

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]