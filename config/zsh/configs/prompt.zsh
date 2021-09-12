#!/usr/bin/env zsh

[ "$TERM" = "dumb" ] && return

export PURE_PROMPT_SYMBOL="↪"

fpath=("$ZDOTDIR/functions/prompt" $fpath)

autoload -U promptinit && promptinit
prompt pure
