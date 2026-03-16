# Prevent Ubuntu's /etc/zsh/zshrc from calling compinit before our plugins
# have added their completions to fpath. We handle compinit ourselves in .zshrc.
skip_global_compinit=1
