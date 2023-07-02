set -eu

# Generate config.xml if GERBERA_CONFIG_XML is not specified.
GERBERA_CONFIG_XML=${GERBERA_CONFIG_XML:-}

# Used only when generating config.xml.
GERBERA_SERVER_NAME=${GERBERA_SERVER_NAME:-Timeshift}
GERBERA_SERVER_UUID=${GERBERA_SERVER_UUID:-4e4f8da3-9bdd-4570-a67c-69ba6f514883}
GERBERA_SCAN_INTERVAL=${GERBERA_SCAN_INTERVAL:-300}
GERBERA_VIDEO_MIMETYPE=${GERBERA_VIDEO_MIMETYPE:-video/mp2t}
GERBERA_VIDEO_DLNA_PROFILE=${GERBERA_VIDEO_DLNA_PROFILE:-MPEG_PS_PAL}

# Typical usage is `GERBERA_EXTRA_OPTIONS='-D'` for debugging purposes.
GERBERA_EXTRA_OPTIONS=${GERBERA_EXTRA_OPTIONS:-}

if [ -z "$GERBERA_CONFIG_XML" ]
then
  GERBERA_CONFIG_XML=/tmp/config.xml
  echo "INFO: Generating $GERBERA_CONFIG_XML..."
  cat <<EOF >$GERBERA_CONFIG_XML
<?xml version="1.0" encoding="UTF-8"?>
<config version="2" xmlns="http://mediatomb.cc/config/2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://mediatomb.cc/config/2 http://mediatomb.cc/config/2.xsd">
  <server>
    <name>$GERBERA_SERVER_NAME</name>
    <udn>uuid:$GERBERA_SERVER_UUID</udn>
    <home>/var/run/gerbera/</home>
    <webroot>/usr/local/share/gerbera/web</webroot>
    <alive>180</alive>
    <storage>
      <sqlite3 enabled="yes">
        <database-file>gerbera.db</database-file>
      </sqlite3>
    </storage>
    <extended-runtime-options>
      <ffmpegthumbnailer enabled="no" />
    </extended-runtime-options>
    <pc-directory upnp-hide="yes" />
  </server>
  <import hidden-files="no">
    <scripting script-charset="UTF-8">
      <virtual-layout type="js">
        <import-script>/usr/local/share/gerbera/js/import.js</import-script>
      </virtual-layout>
    </scripting>
    <autoscan use-inotify="no">
      <directory location="/content" media-types="Video"
                 mode="timed" interval="$GERBERA_SCAN_INTERVAL"
                 recursive="yes" hidden-files="no"
                 container-type-video="object.container" />
    </autoscan>
    <mappings>
      <extension-mimetype ignore-unknown="yes">
        <map from="m2ts" to="$GERBERA_VIDEO_MIMETYPE" />
      </extension-mimetype>
      <contenttype-dlnaprofile>
        <map from="mpeg" to="$GERBERA_VIDEO_DLNA_PROFILE" />
      </contenttype-dlnaprofile>
    </mappings>
  </import>
</config>
EOF
fi

GERBERA_IMPORT_JS_KEEP_ID_PREFIX=${GERBERA_IMPORT_JS_KEEP_ID_PREFIX:-}
if [ "$GERBERA_IMPORT_JS_KEEP_ID_PREFIX" = 1 ]
then
  sed -i -e 's/KEEP_ID_PREFIX = .*;/KEEP_ID_PREFIX = true;/' \
    /usr/local/share/gerbera/js/import.js
fi

GERBERA_IMPORT_JS_LOG_LEVEL=${GERBERA_IMPORT_JS_LOG_LEVEL:-}
if [ -n "$GERBERA_IMPORT_JS_LOG_LEVEL" ]
then
  sed -i -e "s/LOG_LEVEL = .*;/LOG_LEVEL = $GERBERA_IMPORT_JS_LOG_LEVEL;/" \
    /usr/local/share/gerbera/js/import.js
fi

/usr/local/bin/mirakc-timeshift-fs /content &

# The following line must be the same as `CMD` in
# https://github.com/gerbera/gerbera/blob/master/Dockerfile
gerbera --port 49494 --config $GERBERA_CONFIG_XML $GERBERA_EXTRA_OPTIONS
