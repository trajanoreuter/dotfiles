#!/usr/bin/env bash
# =============================================================================
# bootstrap.sh — Single entry point for setting up dotfiles on a new machine.
# Supports macOS (Darwin) and Ubuntu/Debian Linux.
#
# Usage:
#   ./bootstrap.sh [--help]
#
# What it does:
#   1. Detects the OS
#   2. Installs OS-specific packages (Homebrew on macOS, apt on Ubuntu)
#   3. Installs common tools via curl-based installers
#   4. Symlinks dotfiles using GNU Stow
#   5. Installs TPM (tmux plugin manager)
#
# Idempotent: safe to run multiple times — checks before installing.
# =============================================================================

set -e

# ─── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ─── Error Logging ──────────────────────────────────────────────────────────
DOTFILES_DIR_EARLY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ERRORS_DIR="$DOTFILES_DIR_EARLY/.errors"
mkdir -p "$ERRORS_DIR"
ERROR_LOG="$ERRORS_DIR/bootstrap-$(date '+%Y%m%d-%H%M%S').log"

# Tee stderr to both terminal and log file
exec 2> >(tee -a "$ERROR_LOG" >&2)

# ─── Helpers ─────────────────────────────────────────────────────────────────
info()    { printf "${CYAN}[INFO]${RESET}  %s\n" "$*"; }
success() { printf "${GREEN}[OK]${RESET}    %s\n" "$*"; }
skip()    { printf "${YELLOW}[SKIP]${RESET}  %s\n" "$*"; }
error()   { printf "${RED}[ERROR]${RESET} %s\n" "$*" >&2; }
header()  { printf "\n${BOLD}${CYAN}══ %s ══${RESET}\n" "$*"; }

# Track completed steps for final summary
STEPS_DONE=()
record() { STEPS_DONE+=("$1"); }

# ─── Help ────────────────────────────────────────────────────────────────────
show_help() {
  cat <<EOF
${BOLD}bootstrap.sh${RESET} — Dotfiles setup for macOS and Ubuntu

${BOLD}USAGE${RESET}
  ./bootstrap.sh [--help]

${BOLD}OPTIONS${RESET}
  --help    Show this help message and exit

${BOLD}WHAT HAPPENS${RESET}
  macOS:
    • Installs Homebrew (if missing)
    • Installs packages from homebrew/leaves.txt
    • Runs scripts/aerospace.sh, scripts/raycast.sh, scripts/fonts.sh

  Ubuntu/Linux:
    • Runs: sudo apt update && sudo apt install from apt/packages.txt
    • Installs Neovim from GitHub releases (apt version is too old)
    • Installs nvm and Node.js 22 LTS
    • Installs Linuxbrew (if missing)
    • Installs packages from homebrew/leaves-linux.txt (if present)

  Both platforms:
    • Installs GNU Stow (if missing)
    • Runs stow . to symlink dotfiles into \$HOME
    • Runs scripts/bun.sh, scripts/sdkman.sh, scripts/xh.sh
    • Installs tools from GitHub releases (k9s, zellij, wtfutil, yazi, bottom, bat-extras, nushell)
    • Installs TPM (tmux plugin manager)

${BOLD}NOTES${RESET}
  • Idempotent: safe to re-run at any time.
  • Uses \$HOME and \$USER — no hardcoded paths.
  • sudo is only invoked for apt commands on Linux.
EOF
}

if [[ "${1:-}" == "--help" ]]; then
  show_help
  exit 0
fi

# ─── Resolve dotfiles directory ───────────────────────────────────────────────
DOTFILES_DIR="$DOTFILES_DIR_EARLY"
info "Dotfiles directory: $DOTFILES_DIR"
info "Error log: $ERROR_LOG"

# ─── OS Detection ────────────────────────────────────────────────────────────
header "Detecting OS"
OS="$(uname -s)"
case "$OS" in
  Darwin)
    PLATFORM="macos"
    success "Detected: macOS"
    ;;
  Linux)
    if [[ -f /etc/os-release ]]; then
      # shellcheck source=/dev/null
      . /etc/os-release
      if [[ "$ID" == "ubuntu" || "$ID_LIKE" == *"ubuntu"* || "$ID_LIKE" == *"debian"* ]]; then
        PLATFORM="ubuntu"
        success "Detected: Ubuntu/Debian Linux"
      else
        PLATFORM="linux"
        success "Detected: Generic Linux (${PRETTY_NAME:-Linux})"
      fi
    else
      PLATFORM="linux"
      success "Detected: Linux (unknown distribution)"
    fi
    ;;
  *)
    error "Unsupported OS: $OS"
    exit 1
    ;;
esac

# ─── macOS Setup ─────────────────────────────────────────────────────────────
setup_macos() {
  header "macOS Setup"

  # 1. Homebrew
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    success "Homebrew installed"
    record "Homebrew installed"
  else
    skip "Homebrew already installed ($(brew --version | head -1))"
  fi

  # Ensure brew is on PATH (Apple Silicon vs Intel)
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  # 2. Homebrew packages
  LEAVES_FILE="$DOTFILES_DIR/homebrew/leaves.txt"
  if [[ -f "$LEAVES_FILE" ]]; then
    info "Installing Homebrew packages from homebrew/leaves.txt..."
    # Install each package; skip already-installed ones
    while IFS= read -r pkg || [[ -n "$pkg" ]]; do
      [[ -z "$pkg" || "$pkg" == \#* ]] && continue
      # Extract formula name (last component after any tap prefix)
      formula_name="${pkg##*/}"
      if brew list --formula 2>/dev/null | grep -qx "$formula_name"; then
        skip "brew: $pkg (already installed)"
      else
        info "brew install $pkg"
        brew install "$pkg" || error "Failed to install $pkg — continuing"
      fi
    done < "$LEAVES_FILE"
    record "Homebrew packages installed from leaves.txt"
  else
    skip "homebrew/leaves.txt not found — skipping package install"
  fi

  # 3. macOS-specific scripts
  for script in aerospace.sh raycast.sh fonts.sh; do
    script_path="$DOTFILES_DIR/scripts/$script"
    if [[ -f "$script_path" ]]; then
      info "Running scripts/$script..."
      bash "$script_path"
      success "scripts/$script completed"
      record "scripts/$script ran"
    else
      skip "scripts/$script not found — skipping"
    fi
  done
}

# ─── Ubuntu/Linux Setup ──────────────────────────────────────────────────────
setup_ubuntu() {
  header "Ubuntu/Linux Setup"

  # 1. apt update
  info "Running sudo apt update (your sudo password may be required)..."
  sudo apt update
  record "apt update completed"

  # 2. apt packages (install one-by-one so a missing package doesn't block the rest)
  APT_PACKAGES_FILE="$DOTFILES_DIR/apt/packages.txt"
  if [[ -f "$APT_PACKAGES_FILE" ]]; then
    info "Installing apt packages from apt/packages.txt..."
    while IFS= read -r pkg || [[ -n "$pkg" ]]; do
      # Skip blank lines and comments
      [[ -z "$pkg" || "$pkg" =~ ^[[:space:]]*# ]] && continue
      # Trim whitespace
      pkg="$(echo "$pkg" | xargs)"
      [[ -z "$pkg" ]] && continue
      if dpkg -s "$pkg" &>/dev/null; then
        skip "apt: $pkg (already installed)"
      else
        info "apt install $pkg"
        sudo apt install -y "$pkg" || error "Failed to install $pkg — continuing"
      fi
    done < "$APT_PACKAGES_FILE"
    record "apt packages installed"
  else
    skip "apt/packages.txt not found — skipping apt package install"
  fi

  # 3. Neovim (apt version is too old; install from GitHub releases)
  if command -v nvim &>/dev/null && nvim --version | head -1 | grep -qE 'v0\.(1[1-9]|[2-9][0-9])'; then
    skip "Neovim already installed ($(nvim --version | head -1))"
  else
    info "Installing latest Neovim from GitHub releases..."
    NVIM_ARCH="$(uname -m)"
    curl -Lo /tmp/nvim-linux-"$NVIM_ARCH".tar.gz \
      "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz"
    sudo rm -rf /opt/nvim-linux-"$NVIM_ARCH"
    sudo tar -C /opt -xzf /tmp/nvim-linux-"$NVIM_ARCH".tar.gz
    sudo ln -sf /opt/nvim-linux-"$NVIM_ARCH"/bin/nvim /usr/local/bin/nvim
    rm -f /tmp/nvim-linux-"$NVIM_ARCH".tar.gz
    success "Neovim installed ($(nvim --version | head -1))"
    record "Neovim installed from GitHub releases"
  fi

  # 4. nvm (Node Version Manager)
  export NVM_DIR="$HOME/.nvm"
  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    skip "nvm already installed"
    . "$NVM_DIR/nvm.sh"
  else
    info "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    . "$NVM_DIR/nvm.sh"
    success "nvm installed"
    record "nvm installed"
  fi
  if ! nvm ls 22 &>/dev/null; then
    info "Installing Node.js 22 LTS via nvm..."
    nvm install 22
    nvm alias default 22
    success "Node.js $(node --version) installed"
    record "Node.js 22 LTS installed via nvm"
  else
    skip "Node.js 22 already installed via nvm"
  fi

  # 5. Linuxbrew
  if ! command -v brew &>/dev/null; then
    info "Installing Linuxbrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -d "$HOME/.linuxbrew" ]]; then
      eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
    elif [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    success "Linuxbrew installed"
    record "Linuxbrew installed"
  else
    skip "Homebrew/Linuxbrew already installed ($(brew --version | head -1))"
    if [[ -d "$HOME/.linuxbrew" ]]; then
      eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
    elif [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
  fi

  # 6. Linuxbrew packages (if leaves-linux.txt exists)
  LINUX_LEAVES_FILE="$DOTFILES_DIR/homebrew/leaves-linux.txt"
  if [[ -f "$LINUX_LEAVES_FILE" ]] && command -v brew &>/dev/null; then
    info "Installing Linuxbrew packages from homebrew/leaves-linux.txt..."
    while IFS= read -r pkg || [[ -n "$pkg" ]]; do
      [[ -z "$pkg" || "$pkg" == \#* ]] && continue
      formula_name="${pkg##*/}"
      if brew list --formula 2>/dev/null | grep -qx "$formula_name"; then
        skip "brew: $pkg (already installed)"
      else
        info "brew install $pkg"
        brew install "$pkg" || error "Failed to install $pkg — continuing"
      fi
    done < "$LINUX_LEAVES_FILE"
    record "Linuxbrew packages installed from leaves-linux.txt"
  else
    if [[ ! -f "$LINUX_LEAVES_FILE" ]]; then
      skip "homebrew/leaves-linux.txt not found — skipping Linux brew packages"
    fi
  fi
}

# ─── Common Setup (both platforms) ───────────────────────────────────────────
setup_common() {
  header "Common Setup"

  # 1. GNU Stow
  if ! command -v stow &>/dev/null; then
    info "Installing GNU Stow..."
    if [[ "$PLATFORM" == "macos" ]]; then
      brew install stow
    else
      sudo apt install -y stow
    fi
    success "GNU Stow installed"
    record "GNU Stow installed"
  else
    skip "GNU Stow already installed ($(stow --version | head -1))"
  fi

  # 2. Stow dotfiles
  header "Stowing Dotfiles"
  info "Running: stow . (from $DOTFILES_DIR)"
  # Use --restow to be safe on re-runs; conflicts will error out with set -e
  # Temporarily disable set -e so we can give a useful message on conflict
  set +e
  stow_output=$(cd "$DOTFILES_DIR" && stow . 2>&1)
  stow_exit=$?
  set -e
  if [[ $stow_exit -eq 0 ]]; then
    success "Dotfiles symlinked successfully"
    record "Dotfiles stowed"
  else
    error "stow . failed — there may be conflicting files in \$HOME."
    error "Resolve conflicts manually and re-run, or remove conflicting files."
    error "stow output: $stow_output"
    # Don't exit here — allow the rest of the script to continue
  fi

  # 3. bun
  if ! command -v bun &>/dev/null; then
    info "Installing bun..."
    bash "$DOTFILES_DIR/scripts/bun.sh"
    success "bun installed"
    record "bun installed"
  else
    skip "bun already installed ($(bun --version 2>/dev/null || echo 'unknown version'))"
  fi

  # 4. SDKMAN
  if [[ ! -d "$HOME/.sdkman" ]]; then
    info "Installing SDKMAN..."
    # sdkman installer sources itself and requires a login shell; run the curl
    # part only and let the user re-source their shell afterwards
    curl -s "https://get.sdkman.io" | bash
    success "SDKMAN installed — re-source your shell or open a new terminal to use sdk"
    record "SDKMAN installed"
    # Attempt to source sdkman and install kotlin/gradle
    if [[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
      set +e
      # shellcheck source=/dev/null
      source "$HOME/.sdkman/bin/sdkman-init.sh" 2>/dev/null
      sdk install kotlin 2>/dev/null && record "kotlin (sdk) installed"
      sdk install gradle 2>/dev/null && record "gradle (sdk) installed"
      set -e
    fi
  else
    skip "SDKMAN already installed ($HOME/.sdkman)"
  fi

  # 5. xh (httpie alternative)
  if ! command -v xh &>/dev/null; then
    info "Installing xh..."
    bash "$DOTFILES_DIR/scripts/xh.sh"
    success "xh installed"
    record "xh installed"
  else
    skip "xh already installed ($(xh --version 2>/dev/null || echo 'unknown version'))"
  fi

  # 7. Tools installed from GitHub releases (Linux only, Homebrew handles macOS)
  if [[ "$PLATFORM" != "macos" ]]; then
    for tool_entry in \
      "k9s:k9s" \
      "zellij:zellij" \
      "wtfutil:wtfutil" \
      "yazi:yazi" \
      "btm:bottom" \
      "batman:bat-extras" \
      "nu:nushell"; do
      tool_cmd="${tool_entry%%:*}"
      tool_script="${tool_entry##*:}"
      script_path="$DOTFILES_DIR/scripts/${tool_script}.sh"
      if ! command -v "$tool_cmd" &>/dev/null; then
        if [[ -f "$script_path" ]]; then
          info "Installing $tool_script..."
          bash "$script_path"
          success "$tool_script installed"
          record "$tool_script installed"
        else
          skip "scripts/${tool_script}.sh not found — skipping"
        fi
      else
        skip "$tool_script already installed"
      fi
    done
  fi

  # 6. TPM — tmux plugin manager
  TPM_DIR="$HOME/.tmux/plugins/tpm"
  if [[ ! -d "$TPM_DIR" ]]; then
    info "Installing TPM (tmux plugin manager)..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    success "TPM installed at $TPM_DIR"
    record "TPM (tmux plugin manager) installed"
  else
    skip "TPM already installed ($TPM_DIR)"
  fi
}

# ─── Summary ─────────────────────────────────────────────────────────────────
print_summary() {
  header "Bootstrap Summary"
  if [[ ${#STEPS_DONE[@]} -eq 0 ]]; then
    success "Everything was already up to date — nothing to do!"
  else
    success "Completed steps:"
    for step in "${STEPS_DONE[@]}"; do
      printf "  ${GREEN}✔${RESET}  %s\n" "$step"
    done
  fi
  printf "\n"
  info "Reload your shell to pick up new PATH entries:"
  printf "    ${BOLD}exec \$SHELL -l${RESET}\n\n"
}

# ─── Main ─────────────────────────────────────────────────────────────────────
header "Dotfiles Bootstrap — $(date '+%Y-%m-%d %H:%M:%S')"
info "Running as: $USER on $PLATFORM"

case "$PLATFORM" in
  macos)
    setup_macos
    ;;
  ubuntu | linux)
    setup_ubuntu
    ;;
esac

setup_common
print_summary

if [[ ! -s "$ERROR_LOG" ]]; then
  rm -f "$ERROR_LOG"
fi
