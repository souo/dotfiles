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
  export PYENV_ROOT="${HOME}/.pyenv"
fi

# Checks for `.pyenv` file, and suggests to remove it for installing
if ! [ -d "${PYENV_ROOT}" ]; then
    execute  "curl -fsSL https://pyenv.run | bash" "pyenv"
fi
execute  "$PYENV_ROOT/bin/pyenv update" "pyenv update"

python_versions=(3.12.9 3.11.9)

pyenv_install() {

  declare -r VERSION="$2"
  declare -r READABLE_NAME="$1"

  execute "$PYENV_ROOT/bin/pyenv install $VERSION" "$READABLE_NAME"
}

export PYTHON_BUILD_MIRROR_URL_SKIP_CHECKSUM=1
export PYTHON_BUILD_MIRROR_URL="https://registry.npmmirror.com/-/binary/python"

for version in "${python_versions[@]}"; do
  pyenv_install "Pythyon '${version} (pyenv)'" "$version"
done

execute "$PYENV_ROOT/bin/pyenv global 3.12.9" "Set global python version (3.12.9)"



install_package "pipx" "pipx"
