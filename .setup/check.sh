#!/bin/bash
# Renders the repo for this OS into a temp home and syntax-checks the output.
# Never touches the real ~. Usage: .setup/check.sh true|false (work mode)
set -euo pipefail

WORK="${1:?usage: check.sh true|false}"
SRC="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cz() {
  chezmoi --source "$SRC" --destination "$TMP/home" --config "$TMP/chezmoi.toml" \
    --persistent-state "$TMP/state.boltdb" --cache "$TMP/cache" "$@"
}

echo "==> Rendering for $(uname -s), work=$WORK"
mkdir -p "$TMP/home"
cz init --promptBool "Is this a work machine=$WORK"
cz apply --exclude=scripts

echo "==> Checking zsh files"
for file in .zshrc .zprofile .aliases; do
  zsh -n "$TMP/home/$file"
done

echo "==> Checking scripts"
mkdir -p "$TMP/scripts"
for template in "$SRC"/.chezmoiscripts/*.tmpl; do
  script="$TMP/scripts/$(basename "${template%.tmpl}")"
  cz execute-template < "$template" > "$script"
  # Scripts for the other OS render empty
  if [ -s "$script" ]; then
    bash -n "$script"
  else
    rm "$script"
  fi
done
cp "$SRC"/.setup/*.sh "$TMP/home/.local/bin/mousesetup" "$TMP/scripts/"
for script in "$TMP"/scripts/*; do
  bash -n "$script"
done

if command -v shellcheck > /dev/null 2>&1; then
  echo "==> Running shellcheck"
  shellcheck --shell=bash "$TMP"/scripts/*
else
  echo "==> shellcheck not installed, skipping"
fi

echo "==> All checks passed"
