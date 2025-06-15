# We set `dummy` here in order to avoid the `InvalidDefaultArgInFrom` warning,
# but this argument is always specified in build commands.  As a result, `dummy`
# is never used.
ARG TAG=dummy

# gerbera/gerbera is based on alpine.
# Copy binaries together with required shared libraries from mirakc/timeshift-fs:$TAG.
FROM mirakc/timeshift-fs:$TAG AS archive
ADD https://raw.githubusercontent.com/mirakc/mirakc/refs/heads/main/docker/build-scripts/archive.sh /archive.sh
RUN sh /archive.sh >/archive.tar.gz

FROM gerbera/gerbera:1.12.1
RUN --mount=type=bind,from=archive,source=/archive.tar.gz,target=/archive.tar.gz \
    --mount=type=bind,source=./gerbera/setup.sh,target=/setup.sh \
    sh /setup.sh
COPY ./run.sh /run.sh
COPY ./import.js /usr/local/share/gerbera/js/import.js
ENV MIRAKC_CONFIG=/etc/mirakc/config.yml
CMD ["sh", "/run.sh"]
