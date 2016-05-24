#!/usr/bin/env zsh

export PURE_PROMPT_SYMBOL="↪"

fpath=("$HOME/.zsh/functions/prompt" $fpath)

autoload -U promptinit && promptinit
prompt pure
