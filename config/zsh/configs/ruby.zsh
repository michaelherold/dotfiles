#!/usr/bin/env zsh

local dir

[[ -d /usr/share/chruby ]] && dir=/usr/share/chruby
[[ -d /usr/local/share/chruby ]] && dir=/usr/local/share/chruby

source "$dir/chruby.sh"
[[ -z "$CHRUBY_DISABLE_AUTO" ]] && source "$dir/auto.sh"
