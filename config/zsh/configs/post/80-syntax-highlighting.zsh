#!/usr/bin/env zsh

local directory=

case "$(uname)" in
    Darwin)
        directory=${HOMEBREW_PREFIX}/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting
        ;;
    Linux)
        directory=/usr/share/zsh/plugins/zsh-syntax-highlighting
        ;;
    *)
        exit
esac

local filename=${directory}/zsh-syntax-highlighting.zsh

[[ -f $filename ]] && source $filename
