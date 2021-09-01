#!/usr/bin/env zsh

# Chruby for when we have it
[[ -d /usr/share/chruby ]] && {
  source /usr/share/chruby/chruby.sh
  source /usr/share/chruby/auto.sh
}
[[ -d /usr/local/share/chruby ]] && {
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
}
