#!/usr/bin/env zsh

# fbr - checkout git branch (including remote branches)
fbr() {
  local branches branch

  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
            fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fcoc - checkout git commit
fcoc() {
  local commits commit

  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --cycle --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# fd - cd to selected directory
fd() {
  local dir

  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fda - including hidden directories
fda() {
  local dir

  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# fdr - cd to selected parent directory
fdr() {
  local dir
  local declare dirs=()

  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }

  local dir=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
  cd "$dir"
}

# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# fs - search file contents
fs() {
  if hash rg &>/dev/null; then
    rg --column --follow --line-number --no-heading . | fzf
  elif hash ag &>/dev/null; then
    ag --column --follow --nobreak --numbers --noheading . | fzf
  else
    grep --line-buffered --color=never -r "" * | fzf
  fi
}

# fshow - git commit browser
fshow() {
  local out sha q

  while out=$(
      git log --decorate=short --graph --oneline --color=always |
      fzf --cycle --ansi --multi --no-sort --reverse --query="$q" --print-query); do
    q=$(head -1 <<< "$out")
    while read sha; do
      [ -n "$sha" ] && git show --color=always $sha | less -R
    done < <(sed '1d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
  done
}
