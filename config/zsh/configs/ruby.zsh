#!/usr/bin/env zsh

[[ -o interactive ]] || return 0

local rootdir="$ZDOTDIR/share/chruby"

source "$rootdir/chruby.sh"
[ -z "$CHRUBY_DISABLE_AUTO" ] && source "$rootdir/auto.sh"
