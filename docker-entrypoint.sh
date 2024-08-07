#!/bin/sh
set -e

# set WEBUI_Username And WebUI\Password_PBKDF2
if [ -n "${WEBUI_USER}" ] && [ -n "${WEBUI_PASS}" ]; then
    # username
    sed -i "s/WebUI\\\Username.*/WebUI\\\Username=${WEBUI_USER}/g" /var/lib/qBittorrent/config/qBittorrent.conf

    # password
    HASH=$(/var/lib/qBittorrent/bin/passwd "${WEBUI_PASS}")

    sed -i "s|WebUI\\\Password_PBKDF2.*|WebUI\\\Password_PBKDF2=${HASH}|g" /var/lib/qBittorrent/config/qBittorrent.conf
else
    # username
    sed -i "s/WebUI\\\Username.*/WebUI\\\Username=admin/g" /var/lib/qBittorrent/config/qBittorrent.conf

    # password
    HASH=""
    sed -i "s/WebUI\\\Password_PBKDF2.*/WebUI\\\Password_PBKDF2=\"${HASH}\"/g" /var/lib/qBittorrent/config/qBittorrent.conf
fi

# set WEBUI_LANG
if [ -n "${WEBUI_LANG}" ]; then
    sed -i "s/General\\\Locale.*/General\\\Locale=${WEBUI_LANG}/g" /var/lib/qBittorrent/config/qBittorrent.conf
fi

# set WEBUI_PORT
if [ -n "${WEBUI_PORT}" ]; then
    sed -i "s/WebUI\\\Port.*/WebUI\\\Port=${WEBUI_PORT}/g" /var/lib/qBittorrent/config/qBittorrent.conf
fi

# set PEER_PORT
if [ -n "${PEER_PORT}" ]; then
    sed -i "s/Session\\\Port.*/Session\\\Port=${PEER_PORT}/g" /var/lib/qBittorrent/config/qBittorrent.conf
fi

# qbittorrent-nox
qbittorrent-nox --profile=/var/lib

# exec commands
exec "$@"
