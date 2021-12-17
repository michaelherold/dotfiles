#!/usr/bin/env zsh

local directory=

case "$(uname)" in
    Darwin)
        directory=${HOMEBREW_PREFIX}/opt/zsh-autosuggestions/share/zsh-autosuggestions
        ;;
    Linux)
        directory=/usr/share/zsh/plugins/zsh-autosuggestions
        ;;
    *)
        exit
esac

local filename=${directory}/zsh-autosuggestions.zsh

[[ -f $filename ]] && source $filename
