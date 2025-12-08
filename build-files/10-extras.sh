#!/usr/bin/env bash
set -euxo pipefail

# Extras that are not strictly required for base image functionality
sudo dnf config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
sudo dnf -y install tailscale
sudo systemctl preset tailscaled.service
sudo systemctl enable tailscaled.service
