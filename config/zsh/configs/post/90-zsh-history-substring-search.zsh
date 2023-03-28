#!/usr/bin/env zsh

[ "$TERM" = "dumb" ] && return

. ~/.config/zsh/share/plugins/zsh-history-substring-search.zsh

case "$(uname)" in
  Darwin)
    # Bind up and down arrow keys with a hard-coded value
    bindkey "^[[A" history-substring-search-up
    bindkey "^[[B" history-substring-search-down
    ;;
  Linux)
    # Bind up and down dynamically, since it works here
    zmodload zsh/terminfo
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
    ;;
  *)
    ;;
esac

# Bind P and N for emacs mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# Bind k and j for vi mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
