#!/usr/bin/env bash
# Set environment variables

PROXY_STRING="socks5://127.0.0.1:1080"

export http_proxy=$PROXY_STRING
export HTTP_PROXY=$PROXY_STRING

export https_proxy=$PROXY_STRING
export HTTPS_PROXY=$PROXY_STRING

export ftp_proxy=$PROXY_STRING
export FTP_PROXY=$PROXY_STRING

export socks_proxy=$PROXY_STRING
export SOCKS_PROXY=$PROXY_STRING

export all_proxy=$PROXY_STRING
export ALL_PROXY=$PROXY_STRING

export no_proxy="localhost,127.0.0.0/8,::1"

# Update git and npm to use the proxy
if hash git 2>/dev/null; then
  git config --global http.proxy $HTTP_PROXY
  git config --global https.proxy $HTTP_PROXY

fi

if hash npm 2>/dev/null; then
  npm config set proxy $HTTP_PROXY
  npm config set https-proxy $HTTP_PROXY
  # npm config set strict-ssl false
  # npm config set registry "http://registry.npmjs.org/"
fi

echo -e "\nProxy-related environment variables set."
