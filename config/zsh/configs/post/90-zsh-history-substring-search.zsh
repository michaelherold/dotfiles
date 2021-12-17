#!/usr/bin/env zsh

[ "$TERM" = "dumb" ] && return

local directory=

case "$(uname)" in
    Darwin)
        directory=${HOMEBREW_PREFIX}/opt/zsh-history-substring-search/share/zsh-history-substring-search
        ;;
    Linux)
        directory=/usr/share/zsh/plugins/zsh-history-substring-search
        ;;
    *)
        ;;
esac

local filename=${directory}/zsh-syntax-highlighting.zsh

[[ -f $filename ]] && {
  source $filename

  # Bind up and down arrow keys with a hard-coded value
  [[ "$(uname)" == 'Darwin' ]] && {
    bindkey "^[[A" history-substring-search-up
    bindkey "^[[B" history-substring-search-down
  }

  # Bind up and down dynamically, since it works here
  [[ "$(uname)" == 'Linux' ]] && {
    zmodload zsh/terminfo
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
  }

  # Bind P and N for emacs mode
  bindkey -M emacs '^P' history-substring-search-up
  bindkey -M emacs '^N' history-substring-search-down

  # Bind k and j for vi mode
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
}
