#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/../utils.sh"

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   zsh \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf "\n"

"$HERE"/../oh-my-zsh.sh

curl -s https://ohmyposh.dev/install.sh | bash -s
