#!/bin/bash
# Claude Code notification hook. Arg $1 = event: "done" or "input".
# Reads Stop/Notification JSON payload on stdin (.cwd). Native macOS banner, no sound:
#   title    = 🖥️ session - window   (tmux), else 🖥️ project
#   subtitle = 📁 project @ git-branch
#   body     = ✅ Task complete  /  ⌨️ Needs your input
# Uses $HOME, not an absolute path, so it works on every machine that syncs ~/.claude.

event="${1:-done}"

payload="$(cat)"
cwd="$(printf '%s' "$payload" | jq -r '.cwd // empty' 2>/dev/null)"
[ -z "$cwd" ] && cwd="$PWD"

project="$(basename "$cwd")"
sess="$(tmux display-message -p '#S' 2>/dev/null)"       # tmux session, empty if no tmux
win="$(tmux display-message -p '#W' 2>/dev/null)"        # tmux window name
branch="$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)"

# title: "session - window" if in tmux, else project folder
if [ -n "$sess" ]; then
  title="🖥️ $sess - $win"
else
  title="🖥️ $project"
fi

# subtitle: project (+ branch)
subtitle="📁 $project"
[ -n "$branch" ] && subtitle="$subtitle @ $branch"

# body: event emoji + text
case "$event" in
  input) body="🚨 Needs your input" ;;
  *)     body="✅ Task complete" ;;
esac

esc() { printf '%s' "$1" | sed 's/"/\\"/g'; }

osascript -e "display notification \"$(esc "$body")\" with title \"$(esc "$title")\" subtitle \"$(esc "$subtitle")\""
exit 0
