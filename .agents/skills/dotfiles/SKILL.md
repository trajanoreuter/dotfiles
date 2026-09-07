---
name: dotfiles
description: Use when changing this user's shell, terminal, editor, multiplexer or theme configuration on any of their machines (macOS or Omarchy/Arch). Covers where each config lives in ~/dotfiles, how GNU Stow links it into $HOME, how to add aliases/packages/tools portably, and what must stay outside the repo. Triggers - dotfiles, .zshrc, alias, zprofile, stow, bootstrap.sh, tmux.conf, herdr, starship, nvim config, wezterm, ghostty, omarchy theme, "add a tool", "install X on my machines".
---

# dotfiles (~/dotfiles)

One repo for macOS, Ubuntu and Omarchy (Arch + Hyprland). Files are linked
into `$HOME` with GNU Stow, so **edit the copy inside `~/dotfiles`, never the
symlink target's "real" path elsewhere** (they are the same file, but new files
must be created in the repo and stowed).

```
~/dotfiles
├── .zshrc / .zprofile / .zshenv   zsh: zinit plugins, aliases, functions
├── .tmux.conf                     tmux (TPM + catppuccin; Omarchy layer on Linux)
├── .wezterm.lua                   WezTerm (macOS terminal)
├── .config/
│   ├── zsh/omarchy/               portable copy of Omarchy shell helpers (macOS only)
│   ├── nvim/                      Neovim (lazy.nvim, own config, not LazyVim)
│   ├── herdr/                     herdr multiplexer (tmux keybindings ported)
│   ├── starship/starship.toml     prompt
│   ├── zellij/, wtf/, gh/, opencode/
│   └── omarchy/themes/animals/    Omarchy theme (Linux only, see below)
├── .agents/skills/                agent skills (this file); linked by bootstrap.sh
├── arch/packages.txt, arch/aur.txt, apt/packages.txt, homebrew/leaves.txt
├── scripts/*.sh                   curl/GitHub-release installers
└── bootstrap.sh                   idempotent setup: packages → stow → tools
```

## Rules

1. **Aliases are the user's.** Add new ones below `## aliases` in `.zshrc`;
   never rename or remove existing ones. Aliases that replace a base command
   (`cat`, `ping`, `top`, `man`, `kubectl`) are guarded with `command -v` so a
   missing tool does not break the command — keep that pattern.
2. **Every change must work on macOS and Linux.** Guard OS-specific bits with
   `[[ "$OSTYPE" == darwin* ]]` or `[[ -d /usr/share/omarchy ]]`. Never hardcode
   `/home/<user>`; use `$HOME`.
3. **Adding a tool = three places:** `homebrew/leaves.txt` (macOS),
   `arch/packages.txt` (official repo) or `arch/aur.txt` (AUR, via yay), and
   `apt/packages.txt` (or a comment with the manual install). If it has no
   package anywhere, add `scripts/<tool>.sh` and wire it into `bootstrap.sh`.
4. **Omarchy owns** `~/.config/hypr/`, `~/.config/ghostty/`, `~/.config/tmux/`,
   `~/.config/omarchy/` (except `themes/animals`), `~/.bashrc`. Do not add
   those to the repo; edit them in place on the Omarchy machine only.
5. **Omarchy shell defaults are reused, not copied**, on Linux: `.zshrc`
   sources `/usr/share/omarchy/default/bash/{envs,aliases,functions,completions}`
   when present. On macOS the portable subset lives in `.config/zsh/omarchy/`
   (same `tdl`/`hdl`/`fip`/`ff`/`n`/`c`/`cx`/`cy` helpers). Keep both in sync
   when adding a helper the user wants everywhere.
6. **Secrets never go in the repo** (`.config/gcloud`, `.config/github-copilot`,
   herdr runtime state and `.stow-backups/` are gitignored).

## Apply changes

```bash
cd ~/dotfiles && stow --restow .     # link new files (dry run: stow -n -v --restow .)
source ~/.zshrc                      # or the `rens` alias
tmux source ~/.tmux.conf             # tmux; plugins: prefix + I
herdr server reload-config
omarchy theme set animals            # Linux only, after editing the theme
```

Conflicts (a real file already in `$HOME`) are moved by `bootstrap.sh` to
`.stow-backups/<timestamp>/`; do the same by hand rather than deleting.

## Theme

`.config/omarchy/themes/animals/colors.toml` is the single source of colours on
Omarchy: terminal, tmux, nvim (via `lua/trajanoreuter/plugins/omarchy.lua`),
herdr (`theme.name = "terminal"`), bat (`BAT_THEME=ansi`) all follow it. On
macOS the equivalent knob is `config.color_scheme` in `.wezterm.lua`; nvim falls
back to catppuccin there. Do not hardcode colours in individual app configs.

## Checks before finishing

- `zsh -ic 'alias | grep -c .'` still lists every alias; `bash -n bootstrap.sh`.
- `stow -n -v --restow .` shows only the links you intended.
- Mention in the final message which platform you could not test on.
