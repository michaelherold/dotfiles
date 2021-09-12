# give us access to ^Q
stty -ixon

# vi mode
bindkey -v

# handy keybindings
bindkey "^k" up-line-or-history
bindkey "^j" down-line-or-history
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^K" kill-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey "^Q" push-line-or-edit

bindkey -v '^[[3~' delete-char
bindkey -v '^[[H' beginning-of-line
bindkey -v '^[[F' end-of-line

[ -f "/usr/share/fzf/key-bindings.zsh" ] && source "/usr/share/fzf/key-bindings.zsh"
