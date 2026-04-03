#!/usr/bin/env bash
set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
. "$HERE/utils.sh"

print_in_purple "\n • Configuring locales\n\n"

# Ensure en_US.UTF-8 is uncommented in /etc/locale.gen
if ! grep -q "^en_US.UTF-8 UTF-8" /etc/locale.gen; then
    print_in_purple "Enabling en_US.UTF-8 in /etc/locale.gen"
    sudo sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
fi

# Generate locales
execute "sudo locale-gen" "Generating locales"

# Set system-wide locale if not already set
if [[ ! -f /etc/locale.conf ]] || ! grep -q "LANG=en_US.UTF-8" /etc/locale.conf; then
    print_in_purple "Setting system-wide LANG to en_US.UTF-8"
    echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf > /dev/null
fi
