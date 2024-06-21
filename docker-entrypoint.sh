#!/bin/sh
set -e

# set WEBUI_Username And WebUI\Password_PBKDF2
if [ -n "${WEBUI_USER}" ] && [ -n "${WEBUI_PASS}" ]; then
    # username
    sed -i "s/WebUI\\\Username.*/WebUI\\\Username=${WEBUI_USER}/g" /var/lib/qBittorrent/config/qBittorrent.conf

    # password
    # salt https://unix.stackexchange.com/a/230676
    SALT=$(tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c 16)

    # password https://www.openssl.org/docs/man3.0/man1/openssl-kdf.html
    HASH=$(openssl kdf -keylen 64 -kdfopt digest:SHA512 -kdfopt pass:"${WEBUI_PASS}" \
            -kdfopt salt:"${SALT}" -kdfopt iter:100000 PBKDF2)

    # base64
    ENCODED_SALT=$(echo "${SALT}" | base64)
    ENCODED_HASH=$(echo "${HASH}" | base64)

    # Format password for qBittorrent
    QBITTORRENT_HASH="@ByteArray(${ENCODED_SALT}:${ENCODED_HASH})"

    sed -i "s/WebUI\\\Password_PBKDF2.*/WebUI\\\Password_PBKDF2=$(${QBITTORRENT_HASH})/g" /var/lib/qBittorrent/config/qBittorrent.conf
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

# qbittorrent-nox 
qbittorrent-nox --profile=/var/lib

# exec commands
exec "$@"
