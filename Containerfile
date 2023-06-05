ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-base}"
ARG IMAGE_FLAVOR="${IMAGE_FLAVOR:-main}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-$BASE_IMAGE_NAME-$IMAGE_FLAVOR}"
ARG BASE_IMAGE="ghcr.io/ublue-os/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

COPY etc /etc
COPY usr /usr
RUN chmod +x /etc/ublue-lightdm-workaround.sh

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

ADD packages.json /tmp/packages.json
ADD build.sh /tmp/build.sh

RUN /tmp/build.sh && \
    pip install --prefix=/usr yafti && \
    rm -rf /tmp/* /var/* && \
    systemctl enable lightdm && \
    systemctl enable ublue-lightdm-workaround && \
    ostree container commit && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp

RUN ostree container commit
