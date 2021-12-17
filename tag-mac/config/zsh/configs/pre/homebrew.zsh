#!/usr/bin/env zsh

[[ "$(uname)" != 'Darwin' ]] && exit

[ -f "/usr/local/bin/brew" ] && eval $(/usr/local/bin/brew shellenv)
[ -f "/opt/homebrew/bin/brew" ] && eval $(/opt/homebrew/bin/brew shellenv)
