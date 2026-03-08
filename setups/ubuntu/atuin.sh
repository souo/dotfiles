#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=./../utils.sh
. "$HERE/../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Atuin (Shell History) \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if ! cmd_exists "atuin"; then
    execute "curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | sh" "Installing Atuin"
else
    print_success "Atuin"
fi
