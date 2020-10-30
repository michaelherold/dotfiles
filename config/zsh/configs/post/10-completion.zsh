#!/usr/bin/env zsh

[[ "$(uname)" == 'Linux' ]] && {
  fpath=(/usr/share/zsh/site-functions $fpath)
}

fpath=($ZDOTDIR/completion $fpath)

autoload -U compinit || exit

compinit -C

# Force rehash to have completion picking up new commands in path
_force_rehash() { (( CURRENT == 1 )) && rehash; return 1 }
zstyle ':completion:::::' completer _force_rehash \
                                    _complete \
                                    _ignored \
                                    _gnu_generic \
                                    _approximate
zstyle ':completion:*'    completer _complete \
                                    _ignored \
                                    _gnu_generic \
                                    _approximate

# Speed up completion by avoiding partial globs
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' accept-exact-dirs true

# Cache setup
zstyle ':completion:*' use-cache on

# Default colors for listings
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'

# Separate directories from files
zstyle ':completion:*' list-dirs-first true

# Turn on menu selection only when selections do not fit on screen
zstyle ':completion:*' menu true=long select=long

# Separate matches into groups
zstyle ':completion:*:matches' group yes
zstyle ':completion:*' group-name ''

# Always use the most verbose completion
zstyle ':completion:*' verbose true

# Treat sequences of slashes as single slash
zstyle ':completion:*' squeeze-slashes true

# Describe options.
zstyle ':completion:*:options' description yes

# Completion presentation styles.
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[1m -- %d --\e[22m'
zstyle ':completion:*:messages'     format $'\e[1m -- %d --\e[22m'
zstyle ':completion:*:warnings'     format $'\e[1m -- No matches found --\e[22m'

# Ignore hidden files by default
zstyle ':completion:*:(all-|other-|)files'  ignored-patterns '*/.*'
zstyle ':completion:*:(local-|)directories' ignored-patterns '*/.*'
zstyle ':completion:*:cd:*'                 ignored-patterns '*/.*'

# Don't complete completion functions/widgets.
zstyle ':completion:*:functions' ignored-patterns '_*'


# Show ignored patterns if needed.
zstyle '*' single-ignored show

# cd style.
zstyle ':completion:*:cd:*' ignore-parents parent pwd # cd never selects the parent directory (e.g.: cd ../<TAB>)
zstyle ':completion:*:*:cd:*' tag-order local-directories path-directories

# kill style.
zstyle ':completion:*:*:kill:*' command 'ps -a -w -w -u $USER -o pid,cmd --sort=-pid'
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=39=32"

# rm/cp/mv style.
zstyle ':completion:*:(rm|mv|cp):*' ignore-line yes

# Hostnames completion.
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${${${${(f)"$(<~/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}
  ${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*[*?]*}
  ${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}#*[[:blank:]]}}
)'
zstyle ':completion:*:*:*:hosts' ignored-patterns 'ip6*' 'localhost*'
