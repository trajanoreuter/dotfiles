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

# vim mode
zinit ice depth=1

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    blockf \
    zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

zinit light spaceship-prompt/spaceship-prompt
zinit light jeffreytse/zsh-vi-mode

# AUTOSUGGESTIONS, TRIGGER PRECMD HOOK UPON LOAD
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
zinit ice wait="0a" lucid atload="_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# TAB COMPLETIONS
zinit ice wait="0b" lucid blockf
zinit light zsh-users/zsh-completions
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '-- %d --'
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:complete:*:options' sort false
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# FZF
zinit ice from="gh-r" as="command" bpick="*darwin*"
zinit light junegunn/fzf

# FZF BYNARY AND TMUX HELPER SCRIPT
zinit ice lucid wait'0c' as="command" id-as="junegunn/fzf-tmux" pick="bin/fzf-tmux"
zinit light junegunn/fzf

# RIPGREP
zinit ice from="gh-r" as="program" bpick="*apple*" pick="rg"
zinit light BurntSushi/ripgrep

# NEOVIM
zinit ice from="gh-r" as="program" bpick="*macos*" ver="nightly" pick="bin/nvim"
zinit light neovim/neovim

# FORGIT
zinit ice wait lucid
zinit load wfxr/forgit

# LAZYGIT
zinit ice lucid wait="0" as="program" from="gh-r" bpick="*Darwin*" pick="lazygit" atload="alias lg='lazygit'"
zinit light jesseduffield/lazygit

# LAZYDOCKER
zinit ice lucid wait="0" as="program" from="gh-r" bpick="*Darwin*" pick="lazydocker"
zinit light jesseduffield/lazydocker

# FD
zinit ice as="command" from="gh-r" bpick="*apple*" pick="fd"
zinit light sharkdp/fd

# GH-CLI
zinit ice lucid as="command" from="gh-r" bpick="*macOS*" atclone="./gh completion -s zsh > _gh" atpull="%atclone" mv="**/bin/gh* -> gh" pick="usr/bin/gh"
zinit light cli/cli

# BIND MULTIPLE WIDGETS USING FZF
zinit ice lucid wait'0c' multisrc"shell/{completion,key-bindings}.zsh" id-as="junegunn/fzf_completions" pick="/dev/null"
zinit light junegunn/fzf

# FZF-TAB
zinit ice wait="1" lucid
zinit light Aloxaf/fzf-tab

# EXA
zinit ice wait="2" lucid from="gh-r" as="program" mv="bin/exa* -> exa"
zinit light ogham/exa
zinit ice wait blockf atpull'zinit creinstall -q .'

# DELTA
zinit ice lucid wait="0" as="program" from="gh-r" bpick="*apple*" pick="delta"
zinit light dandavison/delta

# DUST
zinit ice wait="2" lucid from="gh-r" as="program" bpick="*darwin*" pick="dust" atload="alias du=dust"
zinit light bootandy/dust

# BOTTOM
zinit ice wait="2" lucid from="gh-r" as="program" bpick='*apple*' pick="btm"
zinit light ClementTsang/bottom

# DUF
zinit ice lucid wait="0" as="program" from="gh-r" bpick='*Darwin*' pick="duf" atload="alias df=duf"
zinit light muesli/duf

# BAT
zinit ice from="gh-r" as="program" pick="bat" bpick="*apple*" atload="alias cat=bat"
zinit light sharkdp/bat

# BAT-EXTRAS
zinit ice lucid wait="1" as="program" pick="src/batgrep.sh"
zinit ice lucid wait="1" as="program" pick="src/batdiff.sh"
zinit light eth-p/bat-extras

# ZSH MANYDOTS MAGIC
zinit ice depth"1" wait lucid pick"manydots-magic" compile"manydots-magic"
zinit light knu/zsh-manydots-magic

# TREE-SITTER
zinit ice as="program" from="gh-r" mv="tree* -> tree-sitter" pick="tree-sitter"
zinit light tree-sitter/tree-sitter

# PRETTYPING
zinit ice lucid wait="" as="program" pick="prettyping" atload="alias ping=prettyping"
zinit load denilsonsa/prettyping

# GLOW
zinit ice lucid wait"0" as"program" from"gh-r" bpick='*Darwin*' pick"glow"
zinit light charmbracelet/glow

## aliases
alias zl="zellij"
alias wtf="wtfutil"
alias caddy="caddy file-server --browse --listen"
alias ls="exa --icons"
alias nq="navi --query"
alias man=batman.sh
alias n=navi
alias vim=nvim
alias vi=nvim
alias v=nvim
alias t=tmux
alias ping="prettyping"
alias renv="source ~/.zshenv"
alias cat=bat
alias k=kubectl
alias python="python3.9"
alias pip='pip3'
alias top=htop
alias tf=terraform
alias lg='lazygit'
alias python='python3'
alias cd='z'

# git aliases
alias g='git'
alias ggpull='git pull origin $(current_branch)'
alias ggpush='git push origin $(current_branch)'
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'
alias glo='git log --online'
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


zinit ice from'gh-r' as'program'
zinit light sei40kr/fast-alias-tips-bin
zinit light sei40kr/zsh-fast-alias-tips


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

## SSM CONFIGS
function aws-ssm-instance-list {
  output=$(aws ssm describe-instance-information --profile "$AWS_PROFILE" --query "InstanceInformationList[*].{Name:ComputerName,Id:InstanceId,IPAddress:IPAddress}" --output text)
  echo "$output"
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

# =============================================================================
#
# Utility functions for zoxide.
#
# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
    \builtin pwd -L
}
# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    # shellcheck disable=SC2164
    \builtin cd -- "$@"
}
# =============================================================================
#
# Hook configuration for zoxide.
#
# Hook to add new entries to the database.
function __zoxide_hook() {
    # shellcheck disable=SC2312
    \command zoxide add -- "$(__zoxide_pwd)"
}
# Initialize hook.
# shellcheck disable=SC2154
if [[ ${precmd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]] && [[ ${chpwd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]]; then
    chpwd_functions+=(__zoxide_hook)
fi

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

# Jump to a directory using only keywords.
function __zoxide_z() {
    # shellcheck disable=SC2199
    if [[ "$#" -eq 0 ]]; then
        __zoxide_cd ~
    elif [[ "$#" -eq 1 ]] && { [[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]$ ]]; }; then
        __zoxide_cd "$1"
    else
        \builtin local result
        # shellcheck disable=SC2312
        result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" && __zoxide_cd "${result}"
    fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
    \builtin local result
    result="$(\command zoxide query --interactive -- "$@")" && __zoxide_cd "${result}"
}

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

function z() {
    __zoxide_z "$@"
}

function zi() {
    __zoxide_zi "$@"
}

# Completions.
if [[ -o zle ]]; then
    __zoxide_result=''

    function __zoxide_z_complete() {
        # Only show completions when the cursor is at the end of the line.
        # shellcheck disable=SC2154
        [[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0

        if [[ "${#words[@]}" -eq 2 ]]; then
            # Show completions for local directories.
            _files -/
        elif [[ "${words[-1]}" == '' ]]; then
            # Show completions for Space-Tab.
            # shellcheck disable=SC2086
            __zoxide_result="$(\command zoxide query --exclude "$(__zoxide_pwd || \builtin true)" --interactive -- ${words[2,-1]})" || __zoxide_result=''

            # Bind '\e[0n' to helper function.
            \builtin bindkey '\e[0n' '__zoxide_z_complete_helper'
            # Send '\e[0n' to console input.
            \builtin printf '\e[5n'
        fi

        # Report that the completion was successful, so that we don't fall back
        # to another completion function.
        return 0
    }

    function __zoxide_z_complete_helper() {
        if [[ -n "${__zoxide_result}" ]]; then
            # shellcheck disable=SC2034,SC2296
            BUFFER="z ${(q-)__zoxide_result}"
            \builtin zle reset-prompt
            \builtin zle accept-line
        else
            \builtin zle reset-prompt
        fi
    }
    \builtin zle -N __zoxide_z_complete_helper

    [[ "${+functions[compdef]}" -ne 0 ]] && \compdef __zoxide_z_complete z
fi
