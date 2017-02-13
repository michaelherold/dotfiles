#!/usr/bin/env zsh

# Add yarn to the path if it's available
whence yarn >/dev/null && {
  export PATH="$PATH:`yarn global bin`"
}
