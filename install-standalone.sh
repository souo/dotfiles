#!/usr/bin/env bash

set -e

CONFIG_SUFFIX=".yaml"

META_DIR="meta"
CONFIG_DIR="configs"

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASE_DIR}"
git submodule update --init --recursive --remote

for config in "${@}"; do
  "${BASE_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASE_DIR}" -c "${META_DIR}/${CONFIG_DIR}/${config}${CONFIG_SUFFIX}"
done
