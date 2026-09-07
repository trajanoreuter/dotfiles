#!/usr/bin/env zsh
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# History — persistente e compartilhado entre terminais (o zsh não salva nada
# sem HISTFILE/SAVEHIST). Tamanho igual ao do bash do Omarchy (32768).
HISTFILE="$HOME/.zsh_history"
HISTSIZE=32768
SAVEHIST=$HISTSIZE
setopt append_history share_history inc_append_history
setopt hist_ignore_all_dups hist_ignore_space hist_reduce_blanks hist_verify

# plugins
zinit light zsh-users/zsh-autosuggestions

zinit light zsh-users/zsh-completions
zinit light jeffreytse/zsh-vi-mode
zinit light Aloxaf/fzf-tab
zinit light zdharma-continuum/fast-syntax-highlighting

# FZF — usa o binário do sistema quando existe (pacman no Omarchy, brew no
# macOS) e só baixa do GitHub via zinit onde não há fzf instalado.
if ! command -v fzf &> /dev/null; then
  if [[ "$OSTYPE" == darwin* ]]; then
    zinit ice from="gh-r" as="command" bpick="*darwin*"
  else
    zinit ice from="gh-r" as="command" bpick="*linux*"
  fi
  zinit light junegunn/fzf
  zinit ice lucid wait'0c' as="command" id-as="junegunn/fzf-tmux" pick="bin/fzf-tmux"
  zinit light junegunn/fzf
fi
# Keybindings (ctrl-r/ctrl-t/alt-c) e completion do fzf. O zsh-vi-mode
# reconfigura o keymap ao iniciar, então isso precisa rodar depois dele.
zvm_after_init_commands+=('command -v fzf &> /dev/null && source <(fzf --zsh 2>/dev/null)')

# Initialize completion system (required for all tab-completions to work)
autoload -Uz compinit && compinit

# Replay compdef calls that zinit plugins captured before compinit was loaded
zinit cdreplay -q

# kubectl completions (must come after compinit so `compdef` is defined)
if command -v kubectl &> /dev/null; then
  source <(kubectl completion zsh)
  command -v kubecolor &> /dev/null && compdef kubecolor=kubectl
fi

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap

# Omarchy (Arch + Hyprland) — só roda onde o Omarchy está instalado.
# Reaproveita os defaults de shell do Omarchy (são compatíveis com zsh):
#   env-bootstrap  OMARCHY_PATH + PATH (mise shims, ~/.local/bin)
#   envs           BAT_THEME=ansi, man via bat, BROWSER, locale
#   aliases        ls via eza, ff/eff, open(), zd, n(), c/cx/cy (agentes), ...
#   functions      compress/decompress, tdl/tds/tsl (tmux), hdl/hds/hsl (herdr),
#                  rsw (rsync on change), fip/dip (ssh port-forward), ssh com
#                  reconexão, ga/gd (worktrees) ...
#   completions    completion do comando `omarchy` (via bashcompinit)
# Aliases pessoais abaixo têm precedência (ex.: cd=z, t=tmux, ga=git add).
if [[ -r /usr/share/omarchy/default/bash/env-bootstrap ]]; then
  # envs só define EDITOR/BROWSER se ainda não existirem; em shell não-login
  # (.zprofile não roda) garante o nvim antes.
  export EDITOR="${EDITOR:-nvim}" VISUAL="${VISUAL:-nvim}"
  source /usr/share/omarchy/default/bash/env-bootstrap
  source "$OMARCHY_PATH/default/bash/envs"
  source "$OMARCHY_PATH/default/bash/aliases"
  source "$OMARCHY_PATH/default/bash/functions"
  autoload -Uz bashcompinit && bashcompinit
  source "$OMARCHY_PATH/default/bash/completions" 2>/dev/null
else
  # Fora do Omarchy (macOS, Ubuntu): cópia portátil dos mesmos helpers —
  # ff/eff, lt, n(), c/cx/cy, tdl/hdl (layouts tmux/herdr), fip/dip, compress.
  [[ -r "$HOME/.config/zsh/omarchy/portable.zsh" ]] && source "$HOME/.config/zsh/omarchy/portable.zsh"
fi

# mise — gerencia node/claude/codex/opencode/gh no Omarchy; no macOS só ativa
# se estiver instalado (brew install mise).
if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

# try — workspaces descartáveis em ~/Work/tries (vem com o Omarchy; no macOS:
# brew install tobi/try/try). Uso: `try <nome>` cria/entra numa pasta datada.
if command -v try &> /dev/null; then
  eval "$(try init ~/Work/tries)"
fi

## aliases
alias op="NODE_TLS_REJECT_UNAUTHORIZED=0 opencode"
alias zl="zellij"
alias lzd="lazydocker"
alias wtf="wtfutil"
alias t=tmux
alias rens="source ~/.zshrc"
alias tf=terraform
alias cd='z'
# Substitutos só quando o binário existe, senão o comando original quebra
# (ex.: `ping` sem prettyping instalado).
command -v batman     &> /dev/null && alias man=batman
command -v prettyping &> /dev/null && alias ping="prettyping"
command -v bat        &> /dev/null && alias cat=bat
command -v htop       &> /dev/null && alias top=htop
if command -v kubecolor &> /dev/null; then
  alias kubectl="kubecolor"
  alias k="kubecolor"
else
  alias k="kubectl"
fi

# vim
alias vim=nvim
alias vi=nvim
alias v=nvim

# python
alias python='python3'
alias pip='pip3'

# git aliases
alias lg='lazygit'
alias g='git'
alias ggpull='git pull origin $(current_branch)'
alias ggpush='git push origin $(current_branch)'
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'
alias glo='git log --oneline'
alias gst='git status'
alias gup='git fetch && git rebase'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias ga='git add'
alias gm='git merge'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'

# Will return the current branch name
 # Usage example: git pull origin $(current_branch)
 #
 function current_branch() {
   ref=$(git symbolic-ref HEAD 2> /dev/null) || return
   echo ${ref#refs/heads/}
 }

 function current_repository() {
   ref=$(git symbolic-ref HEAD 2> /dev/null) || return
   echo $(git remote -v | cut -d':' -f 2)
 }

# Usage `aws-login <PROFILE>`
function aws-login() {
  local creds
  creds=$(aws configure export-credentials --profile $1 --format env 2>/dev/null)
  if [ $? -ne 0 ]; then
    aws sso login --profile $1
    creds=$(aws configure export-credentials --profile $1 --format env)
  fi
  eval "$creds"
}

function aws-list-ec2 {
  aws ec2 describe-instances \
    --profile "$AWS_PROFILE" \
    --filters Name=tag-key,Values=Name \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value}' \
    --output text
}

function kubectlgetall {
  for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    echo "Resource:" $i

    if [ -z "$1" ]
    then
        kubectl get --ignore-not-found ${i}
    else
        kubectl -n ${1} get --ignore-not-found ${i}
    fi
  done
}

function dstop() {
  docker ps -a | fzf --height 40% --layout=reverse --prompt="Select container to stop: " | awk '{print $1}' | xargs docker stop
}

function dRemove() {
  docker ps -a | fzf --height 40% --layout=reverse --prompt="Select container to remove: " | awk '{print $1}' | xargs docker rm
}

function dRemoveImage() {
  docker images | fzf --height 40% --layout=reverse --prompt="Select image to remove: " | awk '{print $1}' | xargs docker rmi
}

function syncPodman() {
  PodmanPath="$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}')"
  DOCKER_HOST="unix://$PodmanPath"
  export DOCKER_HOST
}

function unset-envs() {
  local vars=$(env | sed -n "s/^\($1[^=]*\)=.*/\1/p")
  if [ -n "$vars" ]; then
    echo "Unsetting environment variables matching: $1"
    echo "$vars"
    unset ${(f)vars}
  else
    echo "No environment variables found matching: $1"
  fi
}

function ytd3() {
  local download_dir="$HOME/Music/Downloads"

  if (( $# != 1 )); then
    echo "Usage: ytd3 <youtube-url>" >&2
    return 2
  fi

  yt-dlp \
    --no-playlist \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    --embed-thumbnail \
    --add-metadata \
    -o "$download_dir/%(title)s.%(ext)s" \
    -- \
    "$1"
}

function ytd4() {
  local download_dir="$HOME/Music/Downloads"

  if (( $# != 1 )); then
    echo "Usage: ytd4 <youtube-url>" >&2
    return 2
  fi

  yt-dlp \
    --no-playlist \
    --format "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]/b" \
    --merge-output-format mp4 \
    -o "$download_dir/%(title)s.%(ext)s" \
    -- \
    "$1"
}

function ytdp() {
  local download_dir="$HOME/Music/Downloads"
  local playlist_name="$1"
  local playlist_url="$2"
  local target_dir="$download_dir/$playlist_name"

  if (( $# != 2 )); then
    echo "Usage: ytdp <playlist-folder-name> <playlist-url>" >&2
    return 2
  fi

  mkdir -p "$target_dir" || return

  yt-dlp \
    --yes-playlist \
    --format "bestaudio/best" \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    --embed-thumbnail \
    --add-metadata \
    --download-archive "$target_dir/.yt-dlp-archive.txt" \
    -o "$target_dir/%(playlist_index)03d - %(title)s.%(ext)s" \
    -- \
    "$playlist_url"
}

if command -v thefuck &> /dev/null; then
  eval $(thefuck --alias 2>/dev/null)
  eval $(thefuck --alias fk 2>/dev/null)
fi
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi
if command -v starship &> /dev/null; then
  export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$HOME/.config/starship/starship.toml}"
  eval "$(starship init zsh)"
fi

# OrbStack: command-line tools and integration (macOS only)
if [[ "$OSTYPE" == darwin* ]]; then
  source ~/.orbstack/shell/init.zsh 2>/dev/null || :
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Instaladores de CLI (codex, uv, ...) colocam binários em ~/.local/bin.
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
