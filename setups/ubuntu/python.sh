#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/../utils.sh"

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Python\n\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -z "$PYENV_ROOT" ]; then
  if [ -z "$HOME" ]; then
    printf "$0: %s\n" \
      "Either \$PYENV_ROOT or \$HOME must be set to determine the install location." \
      >&2
    exit 1
  fi
  export PYENV_ROOT="${HOME}/.pyenv"
fi

# Checks for `.pyenv` file, and suggests to remove it for installing
if ! [ -d "${PYENV_ROOT}" ]; then
    execute  "curl -fsSL https://pyenv.run | bash" "pyenv" 
fi


python_versions=(3.12.9 3.11.9)


pyenv_install() {

  declare -r VERSION="$2"
  declare -r READABLE_NAME="$1"

  execute "export PATH=\"$PYENV_ROOT/bin:$PATH\" && pyenv install $VERSION" "$READABLE_NAME"
}

for version in "${python_versions[@]}"; do
  pyenv_install "Pythyon'${version}'" "$version"
done


install_package "pipx" "pipx"