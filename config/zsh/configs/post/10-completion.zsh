#!/usr/bin/env zsh

[[ "$(uname)" == 'Linux' ]] && {
  fpath=(/usr/share/zsh/site-functions $fpath)
  [ -f "/usr/share/fzf/completion.zsh" ] && source "/usr/share/fzf/completion.zsh"
}

[[ "$(uname)" == 'Darwin' && -f "/usr/local/opt/fzf/shell/completion.zsh" ]] && {
  source "/usr/local/opt/fzf/shell/completion.zsh"
}

fpath=($ZDOTDIR/completion $fpath)

autoload -U compinit || exit

compinit -C

# See zshcompsys(1) for the manual on these options

# Always use menu selection
zstyle ':completion:*:*:*:*:*' menu select

# Describe options, with the description if options aren't described
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'

# Separate matches into groups, using all types, with directories first
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*:matches' group yes

# Always use the most verbose completion
zstyle ':completion:*' verbose true

# Try case-insensitive matching, then fuzzy matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' '+r:|?=**'

# Presentation styles
zstyle ':completion:*'              format '%F{cyan}-- %d --%f'
zstyle ':completion:*:corrections'  format '%F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages'     format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings'     format '%F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Cache setup, if any completions use it
# See: _store_cache, _retrieve_cache, and _cache_invalid
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"
zstyle ':completion::complete:*' use-cache on

# Treat sequences of slashes as single slash
zstyle ':completion:*' squeeze-slashes true

# Don't complete completion functions, widgets, or prompt commands
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|prompt_*)'

# Command styles
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true
zstyle ':completion:*:(diff|kill|rm):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'
zstyle ':completion:*:-tilde-:*' group-order named-directories path-directories expand
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
