#!/usr/bin/env bash

set -e

tmux_option() {
  local -r value=$(tmux show-option -gqv gh_notifications_"$1") \
  default="$2"

  if [[ -n "$value" ]]; then
    echo "$value"
  else
    echo "$default"
  fi
}

cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/tmux_gh_notifications"
refresh_interval="$(tmux_option refresh_interval 60)"
fg_color="$(tmux_option fg_color colour0)"
bg_color="$(tmux_option bg_color colour7)"

# BSD stat uses a different interface than the GNU coreutils one
if [[ "$OSTYPE" != darwin* ]]; then
  stat_cmd="stat -c %Y"
# Homebrew installs GNU coreutils with g prefix. Users might have linked those without prefix,
# so explicitly try to use them to avoid erroring in the latter case.
elif command -v gstat &>/dev/null; then
  stat_cmd="gstat -c %Y"
else
  stat_cmd="stat -f %m"
fi

if [[ -f "$cache_file" ]] && [[ $(($(date +%s) - $($stat_cmd "$cache_file"))) -lt "$refresh_interval" ]]; then
  notifications=$(<"$cache_file")
else
  if command -v jq &>/dev/null; then
    notifications=$(gh api notifications | jq length)
  else
    notifications=$(gh api notifications | grep -o 'unread' | wc -l)
  fi
  echo "$notifications" >"$cache_file"
fi

if ((notifications > 0)); then
  echo -n "#[fg=${bg_color}]#[default]"
  echo -n "#[bg=${bg_color},fg=${fg_color},bold] $notifications#[default]"
  echo -n "#[fg=${bg_color}]#[default]"
fi
