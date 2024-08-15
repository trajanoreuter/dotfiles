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

# plugins
# kubectl completions
source <(kubectl completion zsh)
compdef kubecolor=kubectl
#
zinit light zsh-users/zsh-autosuggestions

zinit light zsh-users/zsh-completions
zinit light jeffreytse/zsh-vi-mode
zinit light Aloxaf/fzf-tab
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice from'gh-r' as'program'
zinit light sei40kr/fast-alias-tips-bin
zinit light sei40kr/zsh-fast-alias-tips

# FZF
 zinit ice from="gh-r" as="command" bpick="*darwin*"
 zinit light junegunn/fzf
 zinit ice lucid wait'0c' as="command" id-as="junegunn/fzf-tmux" pick="bin/fzf-tmux"
 zinit light junegunn/fzf
 zinit ice lucid wait'0c' multisrc"shell/{completion,key-bindings}.zsh" id-as="junegunn/fzf_completions" pick="/dev/null"
 zinit light junegunn/fzf
 zinit ice wait="1" lucid
 zinit light Aloxaf/fzf-tab

zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap

## aliases
alias zl="zellij"
alias lzd="lazydocker"
alias wtf="wtfutil"
alias ls="exa --icons"
alias man=batman.sh
alias t=tmux
alias ping="prettyping"
alias rens="source ~/.zshrc"
alias cat=bat
alias kubectl="kubecolor"
alias k="kubecolor"
alias top=htop
alias tf=terraform
alias cd='z'

# vim
alias vim=nvim
alias vi=nvim
alias v=nvim

# python
alias python="python3.9"
alias python='python3'
alias pip='pip3'

# git aliases
alias lg='lazygit'
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

function dstop() {
  docker ps -a | fzf --height 40% --layout=reverse --prompt="Select container to stop: " | awk '{print $1}' | xargs docker stop
}

function dRemove() {
  docker ps -a | fzf --height 40% --layout=reverse --prompt="Select container to remove: " | awk '{print $1}' | xargs docker rm
}

function dRemoveImage() {
  docker images | fzf --height 40% --layout=reverse --prompt="Select image to remove: " | awk '{print $1}' | xargs docker rmi
}

eval $(thefuck --alias)
eval $(thefuck --alias fk)
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
