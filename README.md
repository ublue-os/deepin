# deepin

**This image is experimental**

[![release-please](https://github.com/tulilirockz/ublue-deepin/actions/workflows/release-please.yml/badge.svg)](https://github.com/tulilirockz/ublue-deepin/actions/workflows/release-please.yml)

To try this image, you can use an existing Fedora Silverblue install.

## Rebase over Fedora Silverblue

    rpm-ostree rebase ostree-unverified-registry:ghcr.io/tulilirockz/deepin-main:38

or if you have an NVIDIA GPU:

    rpm-ostree rebase ostree-unverified-registry:ghcr.io/tulilirockz/deepin-nvidia:38

<br>

## Caveats

- Apparently disabling SELinux is necessary for the DDE to work
