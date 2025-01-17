#!/usr/bin/env bash

set -e

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

var='#{gh_notifications}'
gh_script="#($CURRENT_DIR/gh_notifications.sh)"

set_tmux_option() {
  local -r option="$1"
  local -r value=$(tmux show-option -gqv "$option")
  if [[ "$value" == *"$var"* ]]; then
    tmux set-option -gq "$option" "${value//$var/$gh_script}"
  fi
}

set_tmux_option "status-left"
set_tmux_option "status-right"
