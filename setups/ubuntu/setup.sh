#!/usr/bin/env bash

set -eu

HERE=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
update
upgrade


"${HERE}"/build-essentials.sh
"${HERE}"/dev-tools.sh
"${HERE}"/cleanup.sh
