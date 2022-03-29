#!/usr/bin/env zsh

[[ -o interactive ]] || return 0
(( ${+commands[fzf]} )) || return 0

if (( ${+commands[fd]} )); then
    export FZF_DEFAULT_COMMAND="command fd --color always --hidden --exclude .git --type file"
    export FZF_ALT_C_COMMAND="command fd --color always --hidden --exclude .git --type directory"

    _fzf_compgen_path() {
        command fd --color always --hidden --exclude .git --type file . "${1}"
    }

    _fzf_compgen_dir() {
        command fd --color always --hidden --exclude .git --type directory . "${1}"
    }

    export FZF_DEFAULT_OPTS="--ansi ${FZF_DEFAULT_OPTS}"
elif (( ${+commands[fdfind]} )); then
    export FZF_DEFAULT_COMMAND="command fdfind --color always --hidden --exclude .git --type file"
    export FZF_ALT_C_COMMAND="command fdfind --color always --hidden --exclude .git --type directory"

    _fzf_compgen_path() {
        command fdfind --color always --hidden --exclude .git --type file . "${1}"
    }

    _fzf_compgen_dir() {
        command fdfind --color always --hidden --exclude .git --type directory . "${1}"
    }

    export FZF_DEFAULT_OPTS="--ansi ${FZF_DEFAULT_OPTS}"
elif (( ${+commands[rg]} )); then
    export FZF_DEFAULT_COMMAND="command rg -uu --glob '!.git' --files"

    _fzf_compgen_path() {
        command rg --uu --glob '!.git' --files "${1}"
    }

    _fzf_compgen_dir() {
        command find -L "$1" \
            -name .git -prune -o -name .hg -prune -o -name .svn -o -type d \
            -a -not -ath "$1" -print 2>/dev/null | sed 's@^\./@@'
    }
else
    _fzf_compgen_path() {
        echo "$1"
        command find -L "$1" \
            -name .git -prune -o -name .hg -prune -o -name .svn -o \( -type d -o -type f -o -type l \) \
            -a -not -path "$1" -print 2>/dev/null | sed 's@^\./@@'
    }

    _fzf_compgen_dir() {
        command find -L "$1" \
            -name .git -prune -o -name .hg -prune -o -name .svn -o -type d \
            -a -not -ath "$1" -print 2>/dev/null | sed 's@^\./@@'
    }
fi

if (( ${+commands[bat]} )); then
    export FZF_CTRL_T_OPTS="--preview 'command bat --color=always --line-range :500 {}' ${FZF_CTRL_T_OPTS}"
fi

(( ${+FZF_DEFAULT_COMMAND} )) && export FZF_CTRL_T_COMMAND=${FZF_DEFAULT_COMMAND}

export FZF_COMPLETION_OPTS="--border --info=inline"
export FZF_COMPLETION_TRIGGER=":"

###
# Begin fzf's completion.zsh with minor edits
###

__fzf_comprun() {
    if [[ "$(type _fzf_comprun 2>&1)" =~ function ]]; then
        _fzf_comprun "$@"
    elif [ -n "$TMUX_PANE" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "$FZF_TMUX_OPTS" ]; }; then
        shift
        if [ -n "$FZF_TMUX_OPTS" ]; then
            fzf-tmux ${(Q)${(Z+n+)FZF_TMUX_OPTS}} -- "$@"
        else
            fzf-tmux -d ${FZF_TMUX_HEIGHT:-40%} -- "$@"
        fi
    else
        shift
        fzf "$@"
    fi
}

# Extract the name of the command, accounting for leading environment variables
__fzf_extract_command() {
    local token tokens

    tokens=(${(z)1})

    for token in $tokens; do
        token=${(Q)token}

        if [[ "$token" =~ [[:alnum:]] && ! "$token" =~ "=" ]]; then
            echo $token
            return
        fi
    done

    echo "${tokens[1]}"
}

# Generates possible matches for path completion (either paths or directories)
#
# $1 - the base for the search
# $2 - the initial value of LBUFFER
# $3 - the _fzf_compgen_* function to use
# $4 - any fzf options to use
# $5 - any suffix to add to the match
# $6 - the suffix for the resulting LBUFFER
__fzf_generic_path_completion() {
    local base lbuf cmd compgen fzf_opts suffix tail dir leftover matches

    base=$1
    lbuf=$2
    compgen=$3
    fzf_opts=$4
    suffix=$5
    tail=$6
    cmd=$(__fzf_extract_command "$lbuf")

    setopt localoptions nonomatch
    eval "base=$base"
    [[ $base = *"/"* ]] && dir="$base"

    while [ 1 ]; do
        if [[ -z "$dir" || -d ${dir} ]]; then
            leftover=${base/#"$dir"}
            leftover=${leftover/#\/}

            [ -z "$dir" ] && dir='.'
            [ "$dir" != "/" ] && dir="${dir/%\//}"

            matches=$(eval "$compgen $(printf %q "$dir")" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_COMPLETION_OPTS" __fzf_comprun "$cmd" ${(Q)${(Z+n+)fzf_opts}} -q "$leftover" | while read item; do
                          echo -n "${(q)item}$suffix "
                      done)
            matches=${matches% }
            if [ -n "$matches" ]; then
                LBUFFER="$lbuf$matches$tail"
            fi

            zle reset-prompt
            break
        fi

        dir=$(dirname "$dir")
        dir=${dir%/}/
    done
}

# Generates matches for directories
_fzf_dir_completion() {
    __fzf_generic_path_completion "$1" "$2" _fzf_compgen_dir \
        "" "/" ""
}

# Generates matches for files
_fzf_path_completion() {
    __fzf_generic_path_completion "$1" "$2" _fzf_compgen_path \
        "-m" "" " "
}

# Opens a FIFO for capturing arguments
_fzf_feed_fifo() (
    command rm -f "$1"
    mkfifo "$1"
    cat <&0 >"$1" &
)

# Creates the fzf matcher for a command
#
# The first argument becomes the `cmd` and the dispatcher then uses the
# _fzf_complete_<cmd> function to generate candidates.
#
# Anything before a -- gets passed as an fzf argument.
#
# Shows information about the selected value via a _fzf_complete_<cmd>_post.
# function
_fzf_complete() {
    setopt localoptions ksh_arrays
    local args rest str_arg i sep fifo lbuf cmd matches post

    args=("$@")
    sep=

    for i in {0..${#args[@]}}; do
        if [[ "${args[$i]}" = -- ]]; then
            sep=$i
            break
        fi
    done

    if [[ -n "$sep" ]]; then
        str_arg=
        rest=("${args[@]:$((sep + 1)):${#args[@]}}")
        args=("${args[@]:0:$sep}")
    else
        str_arg=$1
        args=()
        shift
        reset=("$@")
    fi

    fifo="${TMPDIR:-/tmp}/fzf-complete-fifo-$$"
    lbuf=${rest[0]}
    cmd=$(__fzf_extract_command "$lbuf")
    post="${funcstack[1]}_post"
    type $post >/dev/null 2>&1 || post=cat

    _fzf_feed_fifo "$fifo"

    matches=$(FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_COMPLETION_OPTS $str_arg" __fzf_comprun "$cmd" "${args[@]}" -q "${(Q)prefix}" < "$fifo" | $post | tr '\n' ' ')
    [ -n "$matches" ] && LBUFFER="$lbuf$matches"

    command rm -f "$fifo"
}

# Generates completions for `telnet`
_fzf_complete_telnet() {
    _fzf_complete +m -- "$@" < <(
        command grep -v '^\s*\(#\|$\)' /etc/hosts | command grep -Fv '0.0.0.0' |
            awk '{ if (length($2) > 0) { print $2 } }' | sort -u
    )
}

# Generates completions for `ssh`
_fzf_complete_ssh() {
    _fzf_complete +m -- "$@" < <(
        setopt localoptions nonomatch

        command cat <(command tail -n +1 ~/.ssh/config ~/.ssh/config.d/* /etc/ssh/ssh_config 2>/dev/null | command grep -i '^\s*host\(name\)\? ' | awk '{for (i = 2; i <= NF; i++) print $1 " " $i}' | command grep -v '[*?]') \
            <(command grep -oE '^[[a-z0-9.,:-]+' ~/.ssh/known_hosts | tr ',' '\n' | tr -d '[' | awk '{ print $1 " " $1 }') \
            <(command grep -v '^\s*\(#\|$\)' /etc/hosts | command grep -Fv '0.0.0.0') |
            awk '{if (length($2) > 0) {print $2}}' | sort -u
    )
}

# Generates completions for `export`
_fzf_complete_export() {
    _fzf_complete -m -- "$@" < <(
        declare -xp | sed 's/=.*//' | sed 's/.* //'
    )
}

# Generates completions for `unset`
_fzf_complete_unset() {
    _fzf_complete -m -- "$@" < <(
        declare -xp | sed 's/=.*//' | sed 's/.* //'
    )
}

# Generates completions for `unalias`
_fzf_complete_unalias() {
    _fzf_complete +m -- "$@" < <(
        alias | sed 's/=.*//'
    )
}

# Generates completions for `kill`
_fzf_complete_kill() {
    _fzf_complete -m --preview 'echo {}' --preview-window down:3:wrap --min-height 15 -- "$@" < <(
        command ps -ef | sed 1d
    )
}

# Generates a preview for `kill`
_fzf_complete_kill_post() {
    awk '{ print $2 }'
}

# A widget for tab completion
fzf-completion-widget() {
    local tokens cmd prefix trigger tail matches lbuf d_cmds
    setopt localoptions noshwordsplit noksh_arrays noposixbuiltins

    tokens=(${(z)LBUFFER})
    if [ ${#tokens} -lt 1 ]; then
        zle ${fzf_default_completion:-expand-or-complete}
        return
    fi

    cmd=$(__fzf_extract_command "$LBUFFER")
    trigger=${FZF_COMPLETION_TRIGGER-'**'}
    [ -z "$trigger" -a ${LBUFFER[-1]} = ' ' ] && tokens+=("")

    if [[ ${LBUFFER} = *"${tokens[-2]}${tokens[-1]}" ]]; then
        tokens[-2]="${tokens[-2]}${tokens[-1]}"
        tokens=(${tokens[0,-2]})
    fi

    lbuf=$LBUFFER
    tail=${LBUFFER:$(( ${#LBUFFER} - ${#trigger} ))}

    if [ "$cmd" = kill -a ${LBUFFER[-1]} = ' ' ]; then
        tail=$trigger
        tokens+=$trigger
        lbuf="$lbuf$trigger"
    fi

    if [ ${#tokens} -gt 1 -a "$tail" = "$trigger" ]; then
        d_cmds=(${=FZF_COMPLETION_DIR_COMMANDS:-cd pushd rmdir})
        [ -z "$trigger"      ] && prefix=${tokens[-1]} || prefix=${tokens[-1]:0:-${#trigger}}
        [ -n "${tokens[-1]}" ] && lbuf=${lbuf:0:-${#tokens[-1]}}

        if eval "type _fzf_complete_${cmd} >/dev/null"; then
            prefix="$prefix" eval _fzf_complete_${cmd} ${(q)lbuf}
            zle reset-prompt
        elif [ ${d_cmds[(i)$cmd]} -le ${#d_cmds} ]; then
            _fzf_dir_completion "$prefix" "$lbuf"
        else
            _fzf_path_completion "$prefix" "$lbuf"
        fi
    else
        zle ${fzf_default_completion:-expand-or-complete}
    fi
}

[ -z "$fzf_default_completion" ] && {
    binding=$(bindkey '^I')
    [[ $binding =~ 'undefined-key' ]] || fzf_default_completion=$binding[(s: :w)2]
    unset binding
}

###
# Begin fzf's key-bindings.zsh with minor edits
###

# A helper function for determining fzf with tmux when in a tmux session
#
# When not in a tmux session, just issue a normal call to fzf
__fzfcmd() {
    [ -n "$TMUX_PANE" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "$FZF_TMUX_OPTS" ]; } &&
        echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " ||
            echo "fzf"
}

# A helper function for listing files for multi-selection
__fzf_select_file() {
    local cmd item ret
    setopt localoptions pipefail no_aliases 2>/dev/null

    cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
        -o -type f -print \
        -o -type d -print \
        -o -type l -print 2>/dev/null | cut -b3-"}"

    eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read item; do
        echo -n "${(q)item} "
    done

    ret=$?
    echo

    return $ret
}

# A widget for multi-selecting files
fzf-file-widget() {
    LBUFFER="${LBUFFER}$(__fzf_select_file)"
    local ret=$?

    zle reset-prompt

    return $ret
}

# A widget for selecting a directory below the current one
fzf-cd-widget() {
    local cmd dir ret
    setopt localoptions pipefail no_aliases 2>/dev/null

    cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
        -o -type d -print 2>/dev/null | cut -b3-"}"
    dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"

    if [[ -z "$dir" ]]; then
        zle redisplay
        return 0
    fi

    zle push-line
    BUFFER="cd -- ${(q)dir}"
    zle accept-line

    ret=$?
    unset dir

    zle reset-prompt

    return $ret
}

# A widget for selecting a line from your HISTFILE
fzf-history-widget() {
    local selected num ret
    setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

    selected=($(fc -rl 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\**\s+(.*)/, $1)}++' |
                    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
    ret=$?

    if [ -n "$selected" ]; then
        num=$selected[1]
        if [ -n "$num" ]; then
            zle vi-fetch-history -n $num
        fi
    fi

    zle reset-prompt

    return $ret
}
