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

(( ${+commands[fzf]} )) && {
    # TAB - Complete with fzf when the cursor is on a FZF_COMPLETION_TRIGGER
    zle -N fzf-completion-widget
    bindkey '^I' fzf-completion-widget

    # Ctrl-T - Paste the selected file path(s) into the command line
    zle -N fzf-file-widget
    bindkey -M emacs '^T' fzf-file-widget
    bindkey -M vicmd '^T' fzf-file-widget
    bindkey -M viins '^T' fzf-file-widget

    # Alt-C - Change to the selected directory
    zle -N fzf-cd-widget
    bindkey -M emacs '\ec' fzf-cd-widget
    bindkey -M vicmd '\ec' fzf-cd-widget
    bindkey -M viins '\ec' fzf-cd-widget

    # Ctrl-R - Paste the selected command from history into the command line
    zle -N fzf-history-widget
    bindkey -M emacs '^R' fzf-history-widget
    bindkey -M vicmd '^R' fzf-history-widget
    bindkey -M viins '^R' fzf-history-widget
}
