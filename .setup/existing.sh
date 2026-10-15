#!/bin/bash
# Sets up chezmoi on a machine that already has dotfiles.
# Backs up every file chezmoi will manage, then asks before each change.
set -e

REPO="${1:-cgallucci99}"
BACKUP="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S).tgz"

log() {
  printf "\n\033[0;34m[DOTFILES]\033[0m %s\n\n" "$1"
}

confirm() {
  read -r -p "$1 [y/N] " reply
  [ "$reply" = "y" ] || [ "$reply" = "Y" ]
}

if ! command -v chezmoi > /dev/null 2>&1; then
  log "Installing chezmoi"
  if command -v brew > /dev/null 2>&1; then
    brew install chezmoi
  else
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi

if [ -d "$(chezmoi source-path 2> /dev/null)" ]; then
  log "chezmoi is already initialized, pulling the latest changes"
  chezmoi update --apply=false
else
  log "Downloading dotfiles (nothing is applied yet)"
  chezmoi init "$REPO"
fi

log "Backing up current files to $BACKUP"
cd "$HOME"
existing="$(mktemp)"
chezmoi managed --include=files --exclude=externals | while read -r path; do
  [ -e "$path" ] && echo "$path"
done > "$existing"
# chezmoi replaces ~/.oh-my-zsh entirely, so keep any customizations in it
[ -d .oh-my-zsh/custom ] && echo ".oh-my-zsh/custom" >> "$existing"
tar czf "$BACKUP" -T "$existing"
rm "$existing"

log "Changes chezmoi would make to your files"
echo "Oh My Zsh and zsh-autosuggestions are also downloaded fresh (not shown)."
if [ -z "$(chezmoi diff --exclude=scripts,externals --no-pager)" ]; then
  echo "None, your files already match."
else
  chezmoi diff --exclude=scripts,externals
  if confirm "Apply these file changes?"; then
    chezmoi apply --exclude=scripts
  else
    log "Stopped before changing anything. Backup: $BACKUP"
    exit 0
  fi
fi

log "Setup scripts that would run (installs, macOS settings, SSH)"
chezmoi status --include=scripts
if confirm "Run these scripts now?"; then
  chezmoi apply
else
  echo "Skipped. Run \`chezmoi apply\` when you're ready."
fi

log "Done. To undo file changes: tar xzf $BACKUP -C ~"
