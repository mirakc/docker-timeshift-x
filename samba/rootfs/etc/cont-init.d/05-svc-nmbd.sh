#!/usr/bin/with-contenv sh
# shellcheck shell=sh

# See https://github.com/crazy-max/docker-samba/tree/master/rootfs/etc/cont-init.d

: "${SAMBA_START_NMBD=}"

# If you start nmbd, you must specify `network_mode: host` in compose.yaml.
if [ -n "$SAMBA_START_NMBD" ]
then
  mkdir -p /etc/services.d/nmbd
  cat <<EOF >/etc/services.d/nmbd/run
#!/usr/bin/execlineb -P
with-contenv
exec nmbd
EOF
  chmod +x /etc/services.d/nmbd/run
fi
