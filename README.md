# dotfiles

Repository to save dot files and configurations. Works on **macOS**, **Ubuntu/Debian**, and **Arch Linux**.

## Quick Start (Recommended)

```bash
git clone https://github.com/trajanoreuter/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

The bootstrap script will:
- Detect your OS (macOS, Ubuntu/Debian, or Arch Linux)
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

### Arch Linux — pacman packages
```bash
# Fresh installation
sudo pacman -Syu
grep -vE '^\s*(#|$)' arch/packages.txt | xargs sudo pacman -S --needed
```

> AUR-only tools are not installed by the pacman package list.
> See comments in `arch/packages.txt` for manual/AUR candidates.

## Structure

```
.zshrc              # Zsh config (zinit plugins, aliases, functions)
.zprofile           # Zsh profile (PATH, env vars, FZF config)
.tmux.conf          # Tmux config (TPM, catppuccin, keybindings)
.wezterm.lua        # WezTerm terminal config
.config/
  herdr/            # Herdr multiplexer (catppuccin, keybindings do tmux)
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
arch/
  packages.txt      # pacman package list (Arch Linux)
scripts/            # Tool-specific install scripts
bootstrap.sh        # Automated setup script
```

## Omarchy (Arch + Hyprland)

On an [Omarchy](https://omarchy.org/) install the repo coexists with the Omarchy
defaults instead of replacing them:

- **Ours (stowed):** zsh, starship, nvim, herdr, opencode, wtf, zellij, gh.
  Omarchy's copies of nvim/herdr/opencode/wtf go to `.stow-backups/<timestamp>/`
  (`bootstrap.sh` does this automatically before `stow`).
- **Omarchy's (not in the repo):** `~/.config/hypr/`, `~/.config/ghostty/`,
  `~/.config/tmux/`, `~/.config/omarchy/`, `~/.bashrc`. Ghostty stays outside the
  repo on purpose: `omarchy font set` rewrites it with `sed -i`, which would
  replace a stow symlink with a plain file.
- **Bridges:**
  - `.zshrc` sources Omarchy's `env-bootstrap`/`envs`/`aliases`/`functions`
    (they are zsh-compatible) and activates mise. Personal aliases win.
  - `.config/nvim/lua/trajanoreuter/plugins/omarchy.lua` reads the active theme
    from `~/.local/state/omarchy/current/theme/neovim.lua`, so `omarchy theme set`
    also themes nvim (catppuccin remains the fallback elsewhere). Restart nvim
    after switching themes.
  - herdr uses `theme.name = "terminal"`, so it follows the terminal palette
    (Omarchy theme on Linux, WezTerm scheme on macOS).
- **One-time local tweaks:** `chsh -s /usr/bin/zsh`; `background-opacity = 0.85`
  in `~/.config/ghostty/config` and `decoration.blur` in
  `~/.config/hypr/looknfeel.lua` to mirror the WezTerm look.
- `bootstrap.sh` skips `pacman -Syu` on Omarchy — use `omarchy update`.

## Cross-Platform Notes

- OS detection uses `$OSTYPE` (zsh) and `uname -s` (bootstrap)
- Homebrew PATH is set conditionally (`/opt/homebrew/bin` on macOS, `/home/linuxbrew/.linuxbrew/bin` on Linux)
- macOS-only tools (AeroSpace, OrbStack, Raycast) are guarded with OS checks
- FZF downloads the correct binary per platform automatically
- WezTerm blur is macOS-only, handled via `wezterm.target_triple`
