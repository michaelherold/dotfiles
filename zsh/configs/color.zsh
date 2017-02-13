# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc. on FreeBSD-based systems
export CLICOLOR=1

# Enable base16 colorschemes on MacOS
[[ `uname` -eq 'Darwin' ]] && {
  BASE16_SHELL=$HOME/.config/base16-shell/
  [ -n "${PS1}" ] && [ -s ${BASE16_SHELL}/profile_helper.sh ] && eval "$(${BASE16_SHELL}/profile_helper.sh)"
}
