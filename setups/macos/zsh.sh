#!/usr/bin/env bash

set -eu

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/../utils.sh"

# shellcheck source=/dev/null
. "$HERE/utils.sh"


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple  "\n   zsh \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf "\n"

"$HERE"/../oh-my-zsh.sh

brew_install "oh-my-posh" "oh-my-posh" "" "jandedobbeleer/oh-my-posh"

brew_install "zsh-autosuggestions" "zsh-autosuggestions"

brew_install "zsh-syntax-highlighting" "zsh-syntax-highlighting"
