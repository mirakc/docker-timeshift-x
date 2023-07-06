set -eu

MIRAKC_TIMESHIFT_MOUNT_POINT=${MIRAKC_TIMESHIFT_MOUNT_POINT:-/mnt}
SAMBA_START_NMBD=${SAMBA_START_NMBD:-}

mkdir -p $MIRAKC_TIMESHIFT_MOUNT_POINT
/usr/local/bin/mirakc-timeshift-fs -o allow_other $MIRAKC_TIMESHIFT_MOUNT_POINT &

# If you start nmbd, you must specify `network_mode: host` in docker-compose.yml.
if [ -n "$SAMBA_START_NMBD" ]
then
  nmbd -D
fi

# The following line must be the same as `CMD` in
# https://github.com/crazy-max/docker-samba/blob/master/Dockerfile
smbd -F --debug-stdout --no-process-group
