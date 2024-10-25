#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   pyenv \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Pyenv
brew_install "pyenv" "pyenv"

# pyenv-virtualenv
brew_install "pyenv-virtualenv" "pyenv-virtualenv"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   pyenv build environment \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pyenv_build_deps=( openssl readline sqlite3 xz zlib tcl-tk )

for dep in "${pyenv_build_deps[@]}"; do
    brew_install "$dep" "$dep"
done
