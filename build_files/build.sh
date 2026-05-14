#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos

dnf5 -y copr enable yalter/niri
dnf5 -y copr enable avengemedia/dms
dnf5 -y copr enable crashdummy/Displaylink
dnf5 -y copr enable scottames/ghostty
dnf5 -y copr enable scottames/vicinae

dnf5 -y install displaylink dms ghostty niri vicinae wiremix wl-mirror tailscale
dnf5 -y group install virtualization

dnf5 -y copr disable yalter/niri
dnf5 -y copr disable avengemedia/dms
dnf5 -y copr disable crashdummy/Displaylink
dnf5 -y copr disable scottames/ghostty
dnf5 -y copr disable scottames/vicinae


systemctl enable podman.socket
systemctl enable tailscaled