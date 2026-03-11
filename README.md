# dotfiles

Repository to save dot files and configurations. Works on **macOS** and **Ubuntu**.

## Quick Start (Recommended)

```bash
git clone https://github.com/trajanoreuter/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

The bootstrap script will:
- Detect your OS (macOS or Ubuntu)
- Install the appropriate package manager and packages
- Symlink all configs via GNU Stow
- Install additional tools (Bun, SDKMAN, TPM, etc.)

## Manual Setup

### Install with stow
```bash
stow .
```

### macOS — Homebrew packages
```bash
# Fresh installation
xargs brew install < homebrew/leaves.txt

# Leaving a machine (to update the list)
brew leaves > homebrew/leaves.txt
```

### Ubuntu — apt packages
```bash
# Fresh installation
sudo apt install $(grep -v '^#' apt/packages.txt | grep -v '^$')
```

> Some tools are not available in apt and need alternative installation.
> See comments in `apt/packages.txt` for instructions.

## Structure

```
.zshrc              # Zsh config (zinit plugins, aliases, functions)
.zprofile           # Zsh profile (PATH, env vars, FZF config)
.tmux.conf          # Tmux config (TPM, catppuccin, keybindings)
.wezterm.lua        # WezTerm terminal config
.config/
  nvim/             # Neovim config (lazy.nvim)
  starship/         # Starship prompt
  zellij/           # Zellij multiplexer
  aerospace/        # AeroSpace window manager (macOS only)
  opencode/         # OpenCode config
  wtf/              # WTF dashboard
  containers/       # Podman config
homebrew/
  leaves.txt        # Homebrew package list (macOS)
apt/
  packages.txt      # apt package list (Ubuntu)
scripts/            # Tool-specific install scripts
bootstrap.sh        # Automated setup script
```

## Cross-Platform Notes

- OS detection uses `$OSTYPE` (zsh) and `uname -s` (bootstrap)
- Homebrew PATH is set conditionally (`/opt/homebrew/bin` on macOS, `/home/linuxbrew/.linuxbrew/bin` on Linux)
- macOS-only tools (AeroSpace, OrbStack, Raycast) are guarded with OS checks
- FZF downloads the correct binary per platform automatically
- WezTerm blur is macOS-only, handled via `wezterm.target_triple`
