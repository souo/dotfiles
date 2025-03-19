#!/usr/bin/env bash

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check if pipx is installed
if ! cmd_exists "pipx"; then
  echo "pipx is not installed. Please install pipx first."
  exit 1
fi

install_pipx_package() {
  declare -r APP_NAME=$2
  if pipx list | grep -q "$APP_NAME"; then
    print_success "$1"
  else
    execute \
      "pipx install $APP_NAME" \
      "$1"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

  print_in_purple "\n  pipx\n\n"

  install_pipx_package "pre-commit" "pre-commit"
  install_pipx_package "uv" "uv"
  install_pipx_package "rich-cli" "rich-cli"

}

main
