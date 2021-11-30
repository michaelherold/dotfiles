setopt hist_ignore_all_dups inc_append_history
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=4096
SAVEHIST=4096

export ERL_AFLAGS="-kernel shell_history enabled"
