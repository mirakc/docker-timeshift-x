if (getPlaylistType(orig.mimetype) === '') {
  // All virtual objects are references to objects in the
  // PC-Directory, so make sure to correctly set the reference ID!
  var obj = orig;
  obj.refID = orig.id;

  const title = obj.title.split('.', 2)[1];  // Drop the ID-prefix in the title.
  const date = computeStartTime(obj);

  obj.title = title;
  obj.metaData[M_TITLE] = [title];
  obj.metaData[M_DATE] = [date];

  const dirs = getRootPath(object_script_path, obj.location);
  const recorder = {
    title: dirs[dirs.length - 1].toUpperCase(),
    objectType: OBJECT_TYPE_CONTAINER,
    upnpclass: UPNP_CLASS_CONTAINER,
    metaData: [],
  };
  recorder.metaData[M_CONTENT_CLASS] = [UPNP_CLASS_VIDEO_ITEM];

  var container = addContainerTree([recorder]);
  addCdsObject(obj, container);
  //print('Imported: ' + orig.location);
}

function computeStartTime(obj) {
  const tzOffset = new Date().getTimezoneOffset();
  const duration = parseDuration(obj);  // in seconds
  const startTime = new Date((obj.mtime - duration - (tzOffset * 60)) * 1000);
  return startTime.toISOString().split('.', 2)[0] + formatTz(tzOffset);
}

function parseDuration(obj) {
  const parts = obj.res.duration.split('.')[0].split(':');  // drop milli-seconds
  return parseInt(parts[0]) * 3600 + parseInt(parts[1]) * 60 + parseInt(parts[2]);
}

function formatTz(tzOffset) {
  var sign = '+';
  if (tzOffset > 0) {
    sign = '-';
  } else {
    tzOffset = -tzOffset;
  }
  const hours = Math.floor(tzOffset / 60);
  const mins = tzOffset % 60;
  return sign + formatDigits(hours) + ':' + formatDigits(mins);
}

function formatDigits(n) {
  if (n < 10) {
    return '0' + n;
  } else {
    return '' + n;
  }
}
