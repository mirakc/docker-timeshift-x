#!/usr/bin/with-contenv sh
# shellcheck shell=sh

# See https://github.com/crazy-max/docker-samba/tree/master/rootfs/etc/cont-init.d

: "${MIRAKC_TIMESHIFT_MOUNT_POINT=/mnt}"

mkdir -p "$MIRAKC_TIMESHIFT_MOUNT_POINT"
mkdir -p /etc/services.d/mirakc-timeshift-fs

cat <<EOF >/etc/services.d/mirakc-timeshift-fs/run
#!/usr/bin/execlineb -P
with-contenv
exec /usr/local/bin/mirakc-timeshift-fs -o allow_other "$MIRAKC_TIMESHIFT_MOUNT_POINT"
EOF
chmod +x /etc/services.d/mirakc-timeshift-fs/run
