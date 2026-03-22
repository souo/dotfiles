#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/../utils.sh"

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Python Ecosystem (mise & pipx) \n\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "Installing Python build dependencies (for mise)..."

# Dependencies required for compiling Python from source
python_build_deps=(
  libssl-dev
  zlib1g-dev
  libbz2-dev
  libreadline-dev
  libsqlite3-dev
  curl
  libncursesw5-dev
  xz-utils
  tk-dev
  libxml2-dev
  libxmlsec1-dev
  libffi-dev
  liblzma-dev
)

for dep in "${python_build_deps[@]}"; do
  install_package "install '${dep}'" "$dep"
done

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   pipx \n\n"

install_package "pipx" "pipx"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   uv \n\n"

if ! cmd_exists "uv"; then
  execute "curl -LsSf https://astral.sh/uv/install.sh | sh" "Installing uv"
else
  print_success "uv"
fi
