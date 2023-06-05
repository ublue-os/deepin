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

FROM fedora:38 as deepinList

# Try to get a list of unversioned packages
RUN dnf group info \
        deepin-desktop \
        deepin-desktop-environment \
	deepin-applications \
    | awk '/^  /' \
    | xargs dnf group info -v  2>/dev/null \
    | awk '($2 == "fedora" || $2 == "updates" || $2 == "@System") && ($1 ~ /noarch/ || $1 ~ /x86_64/){print $1}' \
    |  awk 'NF -= 2{$0=$0; print}' FS='-' OFS='-' \
    | tee /deepin.txt

FROM builder

COPY --from=deepinList /deepin.txt /tmp/deepin.txt

RUN xargs -a /tmp/deepin.txt rpm-ostree install \
    && rm -rf /var/*

RUN ostree container commit
