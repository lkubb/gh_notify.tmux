#!/usr/bin/env bash

set -e

cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/tmux_gh_notifications"
refresh_interval="$(tmux show-option -gqv '@gh_notifications_refresh_interval')"
refresh_interval="${refresh_interval:-60}"

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
  echo -n '#[fg=colour7]#[default]'
  echo -n "#[bg=colour7,fg=colour0,bold] $notifications#[default]"
  echo -n '#[fg=colour7]#[default]'
fi
