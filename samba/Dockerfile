ARG prefix
FROM mirakc/timeshift-fs:${prefix}alpine AS timeshift-fs

FROM crazymax/samba
COPY --from=timeshift-fs /usr/local/bin/mirakc-timeshift-fs /usr/local/bin/
COPY --from=timeshift-fs /etc/mirakc/strings.yml /etc/mirakc/
COPY ./run.sh /run.sh
RUN apk add --no-cache fuse3 tzdata
ENV MIRAKC_CONFIG=/etc/mirakc/config.yml
CMD ["sh", "/run.sh"]
