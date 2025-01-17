# gh_notify.tmux

Add a Github notification widget to your tmux status line.

![image](https://github.com/user-attachments/assets/61043f42-984f-4e68-ae81-3645fca2e85b)


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

