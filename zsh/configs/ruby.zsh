#!/usr/bin/env zsh

# Chruby for when we have it
[[ -f /usr/share/chruby/chruby.sh ]] && {
  source /usr/share/chruby/chruby.sh
  chruby ruby-2.3.1
}

# RVM for work laptop
[[ -d ~/.rvm ]] && export PATH="${PATH}:${HOME}/.rvm/bin"
