# We set `dummy` here in order to avoid the `InvalidDefaultArgInFrom` warning,
# but this argument is always specified in build commands.  As a result, `dummy`
# is never used.
ARG TAG=dummy

# crazymax/samba is based on alpine.
# Copy binaries together with required shared libraries from mirakc/timeshift-fs:$TAG.
FROM mirakc/timeshift-fs:$TAG AS archive
ADD https://raw.githubusercontent.com/mirakc/mirakc/refs/heads/main/docker/build-scripts/archive.sh /archive.sh
RUN sh /archive.sh >/archive.tar.gz

FROM crazymax/samba
RUN --mount=type=bind,from=archive,source=/archive.tar.gz,target=/archive.tar.gz \
    --mount=type=bind,source=./gerbera/setup.sh,target=/setup.sh \
    sh /setup.sh
COPY rootfs /
ENV MIRAKC_CONFIG=/etc/mirakc/config.yml
