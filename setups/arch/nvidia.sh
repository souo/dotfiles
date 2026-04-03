#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=./utils.sh
# shellcheck disable=SC1091
. "$HERE/utils.sh"

print_in_purple "\n • Installing NVIDIA Drivers\n\n"

# Detect kernel and choose driver
kernel=$(uname -r)
if [[ $kernel == *"lts"* ]]; then
    driver="nvidia-lts"
elif [[ $kernel == *"zen"* ]]; then
    driver="nvidia-dkms"
else
    driver="nvidia"
fi

print_in_purple "Detected kernel: $kernel. Installing $driver...\n"

packages=("$driver" "nvidia-utils" "nvidia-settings")

# Install multilib utils if enabled
if grep -q "^\[multilib\]" /etc/pacman.conf; then
    packages+=("lib32-nvidia-utils")
fi

install_packages "${packages[@]}"

print_success "NVIDIA drivers and utilities installed."
print_warning "You may need to reboot for changes to take effect."
