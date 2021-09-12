#!/usr/bin/env zsh

(( ${+commands[fzf]} )) || return

if (( ${+commands[fd]} )); then
    export FZF_DEFAULT_COMMAND="command fd --color always --hidden --no-ignore-vcs --exclude .git --type file"
    export FZF_ALT_C_COMMAND="command fd --color always --hidden --no-ignore-vcs --exclude .git --type directory"

    _fzf_compgen_path() {
        command fd --color always --hidden --no-ignore-vcs --exclude .git --type file "${1}"
    }

    _fzf_compgen_dir() {
        command fd --color always --hidden --no-ignore-vcs --exclude .git --type directory "${1}"
    }

    export FZF_DEFAULT_OPTS="--ansi ${FZF_DEFAULT_OPTS}"
elif (( ${+commands[rg]} )); then
    export FZF_DEFAULT_COMMAND="command rg -uu --glob '!.git' --files"

    _fzf_compgen_path() {
        command rg --uu --glob '!.git' --files "${1}"
    }
fi

if (( ${+commands[bat]} )); then
    export FZF_CTRL_T_OPTS="--preview 'command bat --color=always --line-range :500 {}' ${FZF_CTRL_T_OPTS}"
fi

(( ${+FZF_DEFAULT_COMMAND} )) && export FZF_CTRL_T_COMMAND=${FZF_DEFAULT_COMMAND}
