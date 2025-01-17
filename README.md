# gh_notify.tmux

Add a Github notification widget to your tmux status line.

## Installation

Clone the repo:

```bash
git clone https://github.com/lewis6991/gh_notify.tmux ~/clone/gh_notify.tmux
```

Add this line to the bottom of `.tmux.conf`:

```bash
run-shell ~/clone/gh_notify.tmux/gh_notify.tmux
```

## Usage

Add `#{gh_notifications}` to either `status-left` or `status-right`.

E.g:

```bash
set -g status-right " #{gh_notifications}  %a %e %b  %H:%M "
```

