#!/usr/bin/env zsh

[[ "$(uname)" == 'Darwin' ]] && DIRECTORY=/usr/local/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting
[[ "$(uname)" == 'Linux' ]] && DIRECTORY=/usr/share/zsh/plugins/zsh-syntax-highlighting

FILENAME=${DIRECTORY}/zsh-syntax-highlighting.zsh

[[ -f $FILENAME ]] && source $FILENAME

unset DIRECTORY
unset FILENAME
