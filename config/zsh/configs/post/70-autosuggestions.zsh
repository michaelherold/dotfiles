#!/usr/bin/env zsh

[[ "$(uname)" == 'Linux' ]] && local directory=/usr/share/zsh/plugins/zsh-autosuggestions

local filename=${directory}/zsh-autosuggestions.zsh

[[ -f $filename ]] || return

source $filename
