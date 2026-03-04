#!/usr/bin/env bash

set -e

BASE_CONFIG="base"
CONFIG_SUFFIX=".yaml"

META_DIR="meta"
CONFIG_DIR="configs"
PROFILES_DIR="profiles"

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASE_DIR}"
git submodule update --init --recursive 

while IFS= read -r config; do
    CONFIGS+=" ${config}"
done <"${META_DIR}/${PROFILES_DIR}/$1"

shift

echo "${CONFIGS}"

for config in ${CONFIGS} "${@}"; do
    echo -e "\nConfigure $config"
    configFile="$(mktemp)"
    
    # 1. 处理并写入 Base Config
    sed '1{/^--- *$/d;}' "${BASE_DIR}/${META_DIR}/${BASE_CONFIG}${CONFIG_SUFFIX}" > "$configFile"
    
    # 2. 补一个换行符 (防止前一个文件末尾无换行导致拼接错误)
    echo "" >> "$configFile"
    
    # 3. 处理并追加 当前 Config
    sed '1{/^--- *$/d;}' "${BASE_DIR}/${META_DIR}/${CONFIG_DIR}/${config}${CONFIG_SUFFIX}" >> "$configFile"
    
    "${BASE_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASE_DIR}" -c "$configFile"
    rm -f "$configFile"
done
