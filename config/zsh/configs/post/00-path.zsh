if [[ -d "/usr/local/bin" && ! -z "${PATH##*/usr/local/bin*}" ]]; then
  PATH="/usr/local/bin:$PATH"
fi

# ensure dotfiles bin directory is loaded first
PATH="$HOME/bin:$HOME/.asdf/bin:$HOME/.asdf/shims:/usr/local/sbin:$PATH"

# mkdir .git/safe in the root of repositories you trust
PATH=".git/safe/../../bin:$PATH"

export -U PATH
