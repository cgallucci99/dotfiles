# dotfiles

Managed with [chezmoi](https://www.chezmoi.io). Supports macOS and Linux (Bazzite).

## Install

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/cgallucci99/dotfiles/main/.setup/install.sh)"
```

This installs Xcode CLI tools on macOS, then runs `chezmoi init --apply cgallucci99`.

### On a machine that already has dotfiles

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/cgallucci99/dotfiles/main/.setup/existing.sh)"
```

This backs up every file chezmoi will manage to `~/dotfiles-backup-<date>.tgz`, shows the diff, and asks before applying files and again before running setup scripts. Undo file changes with `tar xzf ~/dotfiles-backup-<date>.tgz -C ~`.

On first run, chezmoi asks **"Is this a work machine"** (default: yes on macOS, no on Linux).

## Work mode

Work machines get:

- Git email `camden.gallucci@bebraven.org` (personal gets `cgallucci99@gmail.com`)
- Braven aliases and the Heroku git credential helper
- `astro`, `heroku`, `libpq`, plus `gcloud-cli` and `ngrok` on macOS
- The work Obsidian vault instead of the personal one

To change it later, edit `work` in `~/.config/chezmoi/chezmoi.toml` and run `chezmoi apply`.

## What it sets up

| | macOS | Linux |
| --- | --- | --- |
| CLI tools | Homebrew | Homebrew (preinstalled on Bazzite) |
| GUI apps | Homebrew casks | Flatpak (Chrome, Bruno, Obsidian, VS Code) |
| Claude Code | `claude-code` cask | Native installer |
| VS Code settings | `~/Library/Application Support/Code` | `~/.config/Code` and the Flatpak path |
| macOS defaults | Yes | No |

Both get Oh My Zsh, zsh-autosuggestions, mise (Node and Ruby), uv/pipx tools, VS Code extensions, Claude config, `~/.ssh/config`, and SSH setup.

## Obsidian vault

Each machine clones one vault over SSH, once. After that, the Obsidian Git plugin keeps it synced.

| Mode | Repo | Folder |
| --- | --- | --- |
| Work | `cgallucci99/work-notes` | `~/Documents/Braven/Work Notes` |
| Personal | `cgallucci99/personal-notes` | `~/Documents/personal-notes` |

- Skips if the folder is already a git repo, or has files but no git
- Open it once in Obsidian with "Open folder as vault"

## SSH key

- Creates `~/.ssh/id_ed25519` only if it doesn't exist
- Labels it with user, host, model, OS, and date, e.g. `camden.gallucci@C73CQ6QP54 · MacBook Pro · macOS 26.6.2 arm64 · 2026-10-15`
- Logs in with `gh` (browser) and uploads the key to GitHub if it isn't there yet

## Bazzite notes

- zsh comes from Homebrew. Bazzite recommends setting it in the terminal profile instead of `chsh`:
  - Terminal settings > profile > "Use Custom Command" > `/home/linuxbrew/.linuxbrew/bin/zsh -l`
- `-l` matters: `~/.zprofile` puts Homebrew on the PATH.
- `mousesetup` needs udev rules first: `sudo rivalcfg --update-udev`
- Not installed on Linux: Ghostty (no Flatpak), Docker Desktop (Bazzite ships Podman), Scroll Reverser

## Not managed

- Apps installed by MDM on the work Mac: Chrome, Slack, Zoom, Claude, DisplayLink
- Secrets in `~/.env` and `~/.config/gh/hosts.yml`

## Checks

Every push runs `.setup/check.sh` on macOS and Ubuntu, in work and personal mode. It renders the repo into a temp folder, then syntax-checks the zsh files and scripts and runs shellcheck.

Run it locally before pushing (never touches `~`):

```sh
.setup/check.sh true   # work mode
.setup/check.sh false  # personal mode
```

## Day to day

- `chezmoi add ~/.somefile` to track a new file
- `chezmoi diff` to preview changes
- `chezmoi apply` to apply them
