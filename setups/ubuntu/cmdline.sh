#!/usr/bin/env bash

HERE

HERE=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# shellcheck source=/dev/null
. "$HERE/../utils.sh"

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - Miscs - - - - - - - - - - - - - - - - - -

apt_packages=(
  telnet
  curl
  git-core
  htop
  jq
  tree
  bat
  fzf
  ripgrep
  tmux
  lazygit
)


print_in_purple "\n   install dev packages \n\n"

for package in "${apt_packages[@]}"; do
    install_package "install '${package}'" "$package"
done
