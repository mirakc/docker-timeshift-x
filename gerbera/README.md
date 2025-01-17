# mirakc/timeshift-gerbera

>  mirakc-timesift-fs + Gerbera

[![main](https://img.shields.io/docker/image-size/mirakc/timeshift-gerbera/main?label=main)](https://hub.docker.com/r/mirakc/timeshift-gerbera/tags?page=1&name=main)

## How to use

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
    image: mirakc/timeshift-gerbera
    restart: unless-stopped
    cap_add:
      - SYS_ADMIN
    # In addition, you might have to run with no apparmor security profile
    # in order to avoid "fusermount3: mount failed: Permission denied".
    #security_opt:
    #  - apparmor:unconfined
    devices:
      - /dev/fuse
    network_mode: host
    volumes:
      # Use the same config.yml
      - /path/to/config.yml:/etc/mirakc/config.yml:ro
      # Timeshift files
      - /path/to/timeshift:/var/lib/mirakc/timeshift:ro
    environment:
      # TZ must be specified.
      TZ: Asia/Tokyo
      RUST_LOG: info
      # Specify the following environment variable if you want to prefix the
      # recording start time in the filename of each record.
      # This is useful if your filesystem does not support the created time
      # attribute.
      #MIRAKC_TIMESHIFT_FS_START_TIME_PREFIX: true
      # See run.sh for other environment variables.
      GERBERA_VIDEO_MIMETYPE: video/mpeg
      GERBERA_VIDEO_DLNA_PROFILE: MPEG_PS_NTSC
      # Enable the following line if you like to keep the ID-prefix in the title
      # of each record.
      #GERBERA_IMPORT_JS_KEEP_ID_PREFIX: 1
```

## Kodi gets stuck when starting playback (Solved)

> The following issue was solved in Kodi 21.1.
> See [this commit](https://github.com/xbmc/xbmc/commit/11331488382c6f3ea450c53a0decc32484193c29) in [xbmc/xbmc](https://github.com/xbmc/xbmc).

This is a known issue.  See the following issues:

* [mirakc/docker-timeshift-x#2](https://github.com/mirakc/docker-timeshift-x/issues/2)
* [gerbera/gerbera#2841](https://github.com/gerbera/gerbera/issues/2841)

Use [mirakc/timeshift-samba](../samba) instead.  If Kodi provides a setting to
disable scanning external subtitle files, mirakc/timeshift-gerbera would work
properly.
