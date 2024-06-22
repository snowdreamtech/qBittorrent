#!/bin/sh
set -e

# set WEBUI_Username And WebUI\Password_PBKDF2
if [ -n "${WEBUI_USER}" ] && [ -n "${WEBUI_PASS}" ]; then
    # username
    sed -i "s/WebUI\\\Username.*/WebUI\\\Username=${WEBUI_USER}/g" /var/lib/qBittorrent/config/qBittorrent.conf

    # password
    HASH=$(python3 /var/lib/qBittorrent/bin/passwd.py "${WEBUI_PASS}")
    sed -i "s/WebUI\\\Password_PBKDF2.*/WebUI\\\Password_PBKDF2=${HASH}/g" /var/lib/qBittorrent/config/qBittorrent.conf
fi

# set WEBUI_LANG
if [ -n "${WEBUI_LANG}" ]; then
    sed -i "s/General\\\Locale.*/General\\\Locale=${WEBUI_LANG}/g" /var/lib/qBittorrent/config/qBittorrent.conf
fi

# set WEBUI_PORT
if [ -n "${WEBUI_PORT}" ]; then
    sed -i "s/WebUI\\\Port.*/WebUI\\\Port=${WEBUI_PORT}/g" /var/lib/qBittorrent/config/qBittorrent.conf
fi

# set TORRENTING_PORT
if [ -n "${TORRENTING_PORT}" ]; then
    sed -i "s/Session\\\Port.*/Session\\\Port=${TORRENTING_PORT}/g" /var/lib/qBittorrent/config/qBittorrent.conf
fi

# flood
flood --host 0.0.0.0 --port "${FLOOD_PORT}" --auth none --qburl "http://localhost:${WEBUI_PORT}" --qbuser "${WEBUI_USER}" --qbpass "${WEBUI_PASS}" > /dev/null 2>&1 &

# qbittorrent-nox 
qbittorrent-nox --profile=/var/lib

# exec commands
exec "$@"
