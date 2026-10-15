# dotfiles

Managed with [chezmoi](https://www.chezmoi.io). macOS only.

## Install on a new Mac

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/cgallucci99/dotfiles/main/.setup/install.sh)"
```

This installs Xcode CLI tools, then runs `chezmoi init --apply cgallucci99`.

## What it sets up

- Homebrew packages and casks (`.chezmoiscripts/run_onchange_before_10-brew-bundle.sh.tmpl`)
- Oh My Zsh and zsh-autosuggestions (`.chezmoiexternal.toml`), with custom theme in `~/.zsh-custom`
- nvm + latest Node, mise tools, uv/pipx tools
- VS Code extensions
- macOS defaults (dark mode, key repeat, Dock, Finder, Scroll Reverser)
- An SSH key, if none exists

## Not managed

- Apps installed by MDM: Chrome, Slack, Zoom, Claude, DisplayLink
- Secrets in `~/.env` and `~/.config/gh/hosts.yml`

## Day to day

- `chezmoi add ~/.somefile` to track a new file
- `chezmoi diff` to preview changes
- `chezmoi apply` to apply them
