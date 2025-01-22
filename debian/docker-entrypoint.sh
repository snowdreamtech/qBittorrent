#!/bin/sh
set -e

QBITTORRENT_CONFIG_PATH=/var/lib/qBittorrent/config/qBittorrent.conf

# WEBUI_USER openssl rand -base64 33
if [ -z "${WEBUI_USER}" ]; then
    {
        WEBUI_USER=$(openssl rand -base64 33)
        echo " Generate Random WEBUI Username : ${WEBUI_USER}"
    }
fi

# WEBUI_PASS openssl rand -base64 33
if [ -z "${WEBUI_PASS}" ]; then
    {
        WEBUI_PASS=$(openssl rand -base64 33)
        echo " Generate Random WEBUI Password : ${WEBUI_PASS}"
    }
fi

# set WEBUI_Username And WebUI\Password_PBKDF2

# Escape a string for a sed replace pattern
# https://stackoverflow.com/a/2705678/22484657
# username
ESCAPED_WEBUI_USER=$(echo "${WEBUI_USER}" | sed -e 's/[]\/$*.^[]/\\&/g')

sed -i "s/WebUI\\\Username.*/WebUI\\\Username=${ESCAPED_WEBUI_USER}/g" "${QBITTORRENT_CONFIG_PATH}"

# password
HASH=$(/var/lib/qBittorrent/bin/passwd "${WEBUI_PASS}")
ESCAPED_HASH=$(echo "${HASH}" | sed -e 's/[]\/$*.^[]/\\&/g')

sed -i "s|WebUI\\\Password_PBKDF2.*|WebUI\\\Password_PBKDF2=\"${ESCAPED_HASH}\"|g" "${QBITTORRENT_CONFIG_PATH}"

# set WEBUI_LANG
if [ -n "${WEBUI_LANG}" ]; then
    sed -i "s/General\\\Locale.*/General\\\Locale=${WEBUI_LANG}/g" "${QBITTORRENT_CONFIG_PATH}"
fi

# set WEBUI_PORT
if [ -n "${WEBUI_PORT}" ]; then
    sed -i "s/WebUI\\\Port.*/WebUI\\\Port=${WEBUI_PORT}/g" "${QBITTORRENT_CONFIG_PATH}"
fi

# set PEER_PORT
if [ -n "${PEER_PORT}" ]; then
    sed -i "s/Session\\\Port.*/Session\\\Port=${PEER_PORT}/g" "${QBITTORRENT_CONFIG_PATH}"
fi

# qbittorrent-nox
# qbittorrent-nox --profile=/var/lib --confirm-legal-notice
qbittorrent-nox --profile=/var/lib

# flood
if [ "${FLOOD_AUTH}" = "default" ]; then
    flood --host 0.0.0.0 --port "${FLOOD_PORT}" --auth default --qburl "http://localhost:${WEBUI_PORT}" --qbuser "${WEBUI_USER}" --qbpass "${WEBUI_PASS}" >/dev/null 2>&1 &
else
    flood --host 0.0.0.0 --port "${FLOOD_PORT}" --auth none --qburl "http://localhost:${WEBUI_PORT}" --qbuser "${WEBUI_USER}" --qbpass "${WEBUI_PASS}" >/dev/null 2>&1 &
fi

# exec commands
if [ -n "$*" ]; then
    sh -c "$*"
fi

# keep the docker container running
# https://github.com/docker/compose/issues/1926#issuecomment-422351028
if [ "${KEEPALIVE}" -eq 1 ]; then
    trap : TERM INT
    tail -f /dev/null &
    wait
    # sleep infinity & wait
fi
