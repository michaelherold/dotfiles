#!/usr/bin/env zsh

[ "$TERM" = "dumb" ] && return

export PURE_GIT_PULL=0
export PURE_PROMPT_SYMBOL="↪"
export PURE_PROMPT_VICMD_SYMBOL="↩️"

fpath=("$ZDOTDIR/functions/prompt" $fpath)

zstyle :prompt:pure:git:dirty color 242

autoload -U promptinit && promptinit
prompt pure
