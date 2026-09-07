# Parte portátil dos aliases/funções do Omarchy (/usr/share/omarchy/default/bash),
# para ter a mesma experiência no macOS. No Omarchy o .zshrc carrega os originais
# e este arquivo NÃO é lido. Aliases pessoais do .zshrc vêm depois e vencem.

# ls via eza (brew install eza)
if command -v eza &> /dev/null; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

# fzf com preview; eff abre o escolhido no $EDITOR
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias eff='$EDITOR "$(ff)"'

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Agentes — mesmos atalhos do Omarchy (c = opencode, cx = claude, cy = codex)
alias c='opencode --auto'
alias cx='printf "\033[2J\033[3J\033[H" && claude --permission-mode auto'
alias cy='codex --approve-for-me'
alias d='docker'
alias mup='MISE_MINIMUM_RELEASE_AGE=0 mise up'
n() { if [ "$#" -eq 0 ]; then command nvim . ; else command nvim "$@"; fi; }

# Git
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

# Layouts de tmux (tdl/tds/tdlm/tsl), herdr (hdl/hds/hdlm/hsl), port-forward
# ssh (fip/dip/lip) e compress/decompress.
for f in "${${(%):-%x}:A:h}"/fns/*.zsh; do source "$f"; done
