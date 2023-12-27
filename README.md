# deepin

**This image is experimental**

[![build](https://github.com/ublue-os/deepin/actions/workflows/build.yml/badge.svg)](https://github.com/ublue-os/deepin/actions/workflows/build.yml)

![Deepin Desktop Showcase Image](deepin-showcase.png)

To try this image, you can use an existing Fedora Silverblue install.

## Rebase over Fedora Silverblue

    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/deepin-main:latest

or if you have an NVIDIA GPU:

    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/deepin-nvidia:latest
