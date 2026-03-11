#fzf
export FZF_DEFAULT_OPTS="
 --ansi
 --layout=default
 --info=inline
 --height=50%
 --multi
 --preview-window=right:50%
 --preview-window=sharp
 --preview-window=cycle
 --preview '([[ -f {} ]] && (bat --style=numbers --color=always --theme=gruvbox-dark --line-range :500 {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
 --prompt='λ -> '
 --pointer='|>'
 --marker='✓'
 --bind 'ctrl-e:execute(nvim {} < /dev/tty > /dev/tty 2>&1)' > selected
 --bind 'ctrl-v:execute(code {+})'"
 export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
 export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
if [[ "$OSTYPE" == darwin* ]]; then
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
fi

# Homebrew PATH (platform-specific)
if [[ "$OSTYPE" == darwin* ]]; then
  export PATH=/opt/homebrew/bin:$PATH
elif [[ "$OSTYPE" == linux* ]]; then
  export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
fi
export PATH=$PATH:$HOME/bin
export EDITOR='nvim'
export VISUAL='nvim'

export STARSHIP_CONFIG=~/.config/starship/starship.toml
