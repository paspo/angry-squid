#!/bin/sh

SQUID_CACHE_DIR=${SQUID_CACHE_DIR:-/var/spool/squid}
SQUID_COREDUMP_DIR=${SQUID_COREDUMP_DIR:-/var/cache/squid}
SQUID_CACHE_SIZE_MB=${SQUID_CACHE_SIZE_MB:-10240}

PIDFILE=/var/run/squid.pid


if [ ! -d "${SQUID_CACHE_DIR}" ]; then
  mkdir -p "${SQUID_CACHE_DIR}"
  chown squid:squid "${SQUID_CACHE_DIR}"
fi

if [ ! -d "${SQUID_COREDUMP_DIR}" ]; then
  mkdir -p "${SQUID_COREDUMP_DIR}"
  chown squid:squid "${SQUID_COREDUMP_DIR}"
fi

cat <<EOF >/etc/squid/conf.d/common.conf
cache_dir aufs ${SQUID_CACHE_DIR} ${SQUID_CACHE_SIZE_MB} 16 256
coredump_dir ${SQUID_COREDUMP_DIR}
EOF

if [ ! -d "${SQUID_CACHE_DIR}/00" ]; then
  squid -z
  sleep 5
fi

[ -e "${PIDFILE}" ] && rm "${PIDFILE}"
squid
tail -f /var/log/squid/access.log /var/log/squid/cache.log
