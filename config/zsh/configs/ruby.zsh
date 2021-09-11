#!/usr/bin/env zsh

local rootdir

[ -d /usr/share/chruby ] && rootdir=/usr/share/chruby
[ -d /usr/local/share/chruby ] && rootdir=/usr/local/share/chruby

[ -z "$rootdir" ] && return

source "$rootdir/chruby.sh"
[ -z "$CHRUBY_DISABLE_AUTO" ] && source "$rootdir/auto.sh"
