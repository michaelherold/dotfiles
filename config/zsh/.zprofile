if [ -f "/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator" ]; then
  IFS=$'\n'
  for line in $(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator | sed 's/\$/\$/g' | sed 's/^/export /g'); do
    [ -n "$line" ] && eval "$line"
  done
fi
