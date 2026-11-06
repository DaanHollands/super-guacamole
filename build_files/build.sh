#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# Used COPR repositories
COPR_REPOS=(
    yalter/niri
    duxlabs/dms
    duxlabs/dux-repo
    crashdummy/Displaylink
    scottames/ghostty
    scottames/vicinae
)

# Enable COPR repos
dnf5 -y copr enable "${COPR_REPOS[@]}"

# Remove conflicting packages
dnf5 -y remove dkms-logitech-trueforce logitech-trueforce

# Install packages
dnf5 -y install displaylink dms ghostty niri vicinae wiremix wl-mirror tailscale
dnf5 -y group install virtualization

# Disable COPR repos in a single command 
dnf5 -y copr disable "${COPR_REPOS[@]}"

# Enable systemd services in a single command
systemctl enable podman.socket tailscaled virtqemud virtnetworkd virtstoraged
