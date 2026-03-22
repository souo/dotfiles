#!/usr/bin/env bash


HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Mise \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# JetBrainsMono Nerd Font
brew_install "mise" "mise"
