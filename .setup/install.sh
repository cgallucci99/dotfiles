#!/bin/sh

if [ "$(uname -s)" = "Darwin" ]; then
  if [ "$(xcode-select --print-path 2> /dev/null)" = "" ]; then
    xcode-select --install > /dev/null 2>&1
  fi

  printf "Waiting for Xcode Command Line Tools to be installed..."
  until [ "$(xcode-select --print-path 2> /dev/null)" != "" ]; do
    sleep 5
    printf '.'
  done
  echo
fi

if command -v curl > /dev/null 2>&1; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply --keep-going cgallucci99
else
  sh -c "$(wget -qO- get.chezmoi.io)" -- init --apply --keep-going cgallucci99
fi
