#!/usr/bin/env zsh

filename=/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

[[ -f $filename ]] && {
  source $filename

  zmodload zsh/terminfo

  # Bind up and down arrow keys
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down

  # Bind P and N for emacs mode
  bindkey -M emacs '^P' history-substring-search-up
  bindkey -M emacs '^N' history-substring-search-down

  # Bind k and j for vi mode
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
}

unset filename
