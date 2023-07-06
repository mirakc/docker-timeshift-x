# mirakc/timeshift-samba

> mirakc-timeshift-fs + Samba

[![main](https://img.shields.io/docker/image-size/mirakc/timeshift-samba/main?label=main)](https://hub.docker.com/r/mirakc/timeshift-samba/tags?page=1&name=main)

## How to use

docker-compose.yml

```yaml
services:
  mirakc:
    ...
    volumes:
      - /path/to/config.yml:/etc/mirakc/config.yml:ro
      - /path/to/timeshift:/var/lib/mirakc/timeshift
    ...

  timeshift:
    container_name: timeshift
    image: mirakc/timeshift-samba
    restart: unless-stopped
    cap_add:
      - SYS_ADMIN
    # In addition, you might have to run with no apparmor security profile
    # in order to avoid "fusermount3: mount failed: Permission denied".
    #security_opt:
    #  - apparmor:unconfined
    devices:
      - /dev/fuse
    ports:
     - 445:445
    volumes:
      # Used in crazymax/samba.
      - /path/to/data:/data
      # Use the same config.yml
      - /path/to/config.yml:/etc/mirakc/config.yml:ro
      # Timeshift files
      - /path/to/timeshift:/var/lib/mirakc/timeshift:ro
    environment:
      # TZ must be specified.
      TZ: Asia/Tokyo
      RUST_LOG: info
      MIRAKC_TIMESHIFT_MOUNT_POINT: /tmp/timeshift
      # See https://github.com/crazy-max/docker-samba for other environment
      # variables.
      SAMBA_SERVER_STRING: Timeshift
```

/path/to/data/config.yml

```yaml
share:
  - name: timeshift
    comment: Timeshift
    path: /tmp/timeshift
    browsable: yes
    readonly: yes
    guestok: yes
    veto: no
```
