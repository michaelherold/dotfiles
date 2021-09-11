# give us access to ^Q
stty -ixon

# vi mode
bindkey -v

# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^K" kill-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey "^Q" push-line-or-edit
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

bindkey -v '^[[3~' delete-char
bindkey -v '^[[H' beginning-of-line
bindkey -v '^[[F' end-of-line
