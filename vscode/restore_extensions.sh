#!/usr/bin/env bash

BASEDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck disable=SC1091
. "$BASEDIR"/../setups/utils.sh


installed="$(code --list-extensions | sort)"

for item in $installed; do
  print_success "$item"
done
