#!/usr/bin/env zsh

[ "$TERM" = "dumb" ] && return

if command -v starship >/dev/null && [ -z "$DISABLE_STARSHIP" ]; then
  eval "$(starship init zsh)"
else
  export PURE_PROMPT_SYMBOL="↪"

  fpath=("$ZDOTDIR/functions/prompt" $fpath)

  autoload -U promptinit && promptinit
  prompt pure
fi
