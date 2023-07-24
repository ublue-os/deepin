ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-base}"
ARG IMAGE_FLAVOR="${IMAGE_FLAVOR:-main}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-$BASE_IMAGE_NAME-$IMAGE_FLAVOR}"
ARG BASE_IMAGE="ghcr.io/ublue-os/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

COPY usr /usr
ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

ADD packages.json /tmp/packages.json
ADD build.sh /tmp/build.sh

RUN chmod +x /usr/etc/ublue-lightdm-workaround.sh && \
    cp /usr/etc/ublue-lightdm-workaround.sh /etc/ && \
    cp /usr/etc/systemd/system/ublue-lightdm-workaround.service /etc/systemd/system/ && \
    /tmp/build.sh && \
    rm -rf /tmp/* /var/* && \
    systemctl enable lightdm && \
    systemctl enable ublue-lightdm-workaround && \
    ostree container commit && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp

RUN ostree container commit
