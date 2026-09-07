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
  omarchy/themes/   # Omarchy theme "animals" (colors.toml + bg + icons)
  zsh/omarchy/      # Portable copy of Omarchy shell helpers (macOS/non-Omarchy)
.agents/skills/     # Agent skills (Claude Code, Codex, opencode); linked by bootstrap.sh
  containers/       # Podman config
homebrew/
  leaves.txt        # Homebrew package list (macOS)
apt/
  packages.txt      # apt package list (Ubuntu)
arch/
  packages.txt      # pacman package list (Arch Linux)
  aur.txt           # AUR package list (installed with yay when available)
scripts/            # Tool-specific install scripts
bootstrap.sh        # Automated setup script
```

## Omarchy (Arch + Hyprland)

On an [Omarchy](https://omarchy.org/) install the repo coexists with the Omarchy
defaults instead of replacing them:

- **Ours (stowed):** zsh, starship, nvim, herdr, opencode, wtf, zellij, gh.
  Omarchy's copies of nvim/herdr/opencode/wtf go to `.stow-backups/<timestamp>/`
  (`bootstrap.sh` does this automatically before `stow`).
- **Ours (stowed) — tema:** `.config/omarchy/themes/animals/` é um tema próprio
  (paleta tirada de `bg/964459.jpg`, a capa do *Animals*). Stow linka só essa
  pasta dentro de `~/.config/omarchy/themes/`; o resto de `~/.config/omarchy/`
  continua do Omarchy. `bootstrap.sh` aplica com `omarchy theme set animals`.
- **Omarchy's (not in the repo):** `~/.config/hypr/`, `~/.config/ghostty/`,
  `~/.config/tmux/`, `~/.config/omarchy/`, `~/.bashrc`. Ghostty stays outside the
  repo on purpose: `omarchy font set` rewrites it with `sed -i`, which would
  replace a stow symlink with a plain file.
- **Bridges (Linux):**
  - `.zshrc` sources Omarchy's `env-bootstrap`/`envs`/`aliases`/`functions`/
    `completions` (they are zsh-compatible; `completions` via `bashcompinit`) and
    activates `mise` and `try`. Personal aliases win (`cd=z`, `t=tmux`, `ga=git add`).
  - `.tmux.conf` sources `~/.config/tmux/tmux.conf` (Omarchy) right after TPM, so
    the status bar follows the active theme (ANSI colours) and Omarchy's extras
    come along (`C-Space` as second prefix, `M-1..9`, `M-Enter`, `prefix ?`).
    Everything below that line in `.tmux.conf` still wins (`C-b`, `h/j/k/l`,
    `M-arrows` for panes, `S-arrows` for windows).
  - `.config/nvim/lua/trajanoreuter/plugins/omarchy.lua` reads the active theme
    from `~/.local/state/omarchy/current/theme/neovim.lua`, so `omarchy theme set`
    also themes nvim (catppuccin remains the fallback elsewhere). Restart nvim
    after switching themes.
  - herdr uses `theme.name = "terminal"` and bat uses `BAT_THEME=ansi`, so both
    follow the terminal palette (Omarchy theme on Linux, WezTerm scheme on macOS).
- **Bridges (macOS / non-Omarchy):** `.config/zsh/omarchy/` is a portable copy of
  the Omarchy shell helpers (`ff`/`eff`, `lt`, `n`, `c`/`cx`/`cy`, `tdl`/`tds`/`tsl`
  tmux layouts, `hdl`/`hds`/`hsl` herdr layouts, `fip`/`dip`/`lip` ssh
  port-forwarding, `compress`/`decompress`). `.zshrc` loads it only when
  `/usr/share/omarchy` is absent, so the same muscle memory works on both machines.
- **Agent skills:** `.agents/skills/<name>/` (currently `dotfiles`, which teaches
  Claude Code / Codex / opencode how this repo works). `bootstrap.sh` symlinks
  each one into `~/.agents/skills`, `~/.claude/skills` and `~/.codex/skills`
  (only where the agent is installed); opencode picks it up through
  `.config/opencode/skills/dotfiles`. Omarchy's own skills (`omarchy`,
  `diagnose-crash`) are Linux-only and stay where Omarchy installs them.
- **Packages:** `arch/packages.txt` (official repos) and `arch/aur.txt` (AUR via
  `yay`, which Omarchy ships). `bootstrap.sh` skips `pacman -Syu` on Omarchy — use
  `omarchy update`.
- **One-time local tweaks:** `chsh -s /usr/bin/zsh`; `background-opacity = 0.85`
  in `~/.config/ghostty/config` and `decoration.blur` in
  `~/.config/hypr/looknfeel.lua` to mirror the WezTerm look.

## Cross-Platform Notes

- OS detection uses `$OSTYPE` (zsh) and `uname -s` (bootstrap)
- Homebrew PATH is set conditionally (`/opt/homebrew/bin` on macOS, `/home/linuxbrew/.linuxbrew/bin` on Linux)
- macOS-only tools (AeroSpace, OrbStack, Raycast) are guarded with OS checks
- FZF downloads the correct binary per platform automatically
- WezTerm blur is macOS-only, handled via `wezterm.target_triple`
