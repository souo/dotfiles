#!/usr/bin/env bash

BASEDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck disable=SC1091
. "$BASEDIR"/../setups/utils.sh

os_name="$(get_os)"
OUTPATH=$BASEDIR/backups/vscode_extensions_"$os_name"

code --list-extensions | sort > "$OUTPATH"
