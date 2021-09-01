#!/usr/bin/env zsh

[[ "$(uname)" == 'Darwin' ]] && local directory=/usr/local/opt/zsh-autosuggestions/share/zsh-autosuggestions
[[ "$(uname)" == 'Linux' ]] && local directory=/usr/share/zsh/plugins/zsh-autosuggestions

local filename=${directory}/zsh-autosuggestions.zsh

[[ -f $filename ]] || return

source $filename
