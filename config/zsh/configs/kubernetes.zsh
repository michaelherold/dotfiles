#!/usr/bin/env zsh

[ -x "$(command -v kubectl)" ] && {
  export KUBE_NAMESPACE="default"

  alias kc='kubectl --namespace="$KUBE_NAMESPACE"'

  # Run a shell within a given container in a pod
  function kcsh {
    local pod="$1"
    local container="$2"

    kc exec $pod -c $container --tty -i -- env COLUMNS=$COLUMNS ROWS=$ROWS TERM=$TERM bash
  }

  # Switch our default namespace for all subsequent commands
  function use-namespace {
    local namespace="$1"

    [ -z "$namespace" ] && namespace="default"

    export KUBE_NAMESPACE="$namespace"
  }
}
