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
    scottames/vicinae
)

# Enable COPR repos one by one
for repo in "${COPR_REPOS[@]}"; do
    dnf5 -y copr enable "$repo"
done

# Remove conflicting packages
# dnf5 -y remove dkms-logitech-trueforce logitech-trueforce

# Install packages
dnf5 -y install dms ghostty niri vicinae wiremix wl-mirror tailscale
dnf5 -y group install virtualization

# Fetch the displaylink RPM and install it without dependency checks
mkdir -p /tmp/dl && cd /tmp/dl
dnf5 download displaylink
rpm -ivh --nodeps displaylink-*.rpm
cd / && rm -rf /tmp/dl

# Disable COPR repos one by one
for repo in "${COPR_REPOS[@]}"; do
    dnf5 -y copr disable "$repo"
done

# Enable systemd services in a single command
systemctl enable podman.socket tailscaled virtqemud virtnetworkd virtstoraged
