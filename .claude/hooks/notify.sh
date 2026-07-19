#!/bin/bash
# Claude Code notification hook. Arg $1 = event: "done" or "input".
# Reads Stop/Notification JSON payload on stdin (.cwd).
# Banner (no sound):
#   title    = 🖥️ session - window (tmux), else 🖥️ project
#   subtitle = 📁 project @ git-branch
#   body     = ✅ Task complete / 🚨 Needs your input
# Click-to-focus: with terminal-notifier, clicking activates Ghostty and jumps
# tmux to the exact pane that fired. Falls back to a plain osascript banner on
# machines without terminal-notifier. Uses $HOME — portable across synced PCs.

event="${1:-done}"

payload="$(cat)"
cwd="$(printf '%s' "$payload" | jq -r '.cwd // empty' 2>/dev/null)"
[ -z "$cwd" ] && cwd="$PWD"

project="$(basename "$cwd")"
sess="$(tmux display-message -p '#S' 2>/dev/null)"   # tmux session, empty if none
win="$(tmux display-message -p '#W' 2>/dev/null)"    # tmux window name
pane="${TMUX_PANE:-$(tmux display-message -p '#{pane_id}' 2>/dev/null)}"  # stable pane id
branch="$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)"

# title / subtitle / body
if [ -n "$sess" ]; then title="🖥️ $sess - $win"; else title="🖥️ $project"; fi
subtitle="📁 $project"; [ -n "$branch" ] && subtitle="$subtitle @ $branch"
case "$event" in
  input) body="🚨 Needs your input" ;;
  *)     body="✅ Task complete" ;;
esac

# --- preferred path: terminal-notifier with click-to-focus ---
if command -v terminal-notifier >/dev/null 2>&1; then
  # click action: focus Ghostty, then jump tmux to the firing pane.
  # switch-client -t <pane-id> resolves session+window+pane in one step and works
  # across MULTIPLE tmux sessions (pane ids like %227 are globally unique). It moves
  # the attached client; if no client is attached there's nothing to switch (Ghostty
  # still comes to front). select-pane also runs in case switch-client lands on the
  # right window but not the exact pane.
  click="osascript -e 'tell application id \"com.mitchellh.ghostty\" to activate'"
  if [ -n "$pane" ]; then
    click="$click; tmux switch-client -t '$pane' 2>/dev/null; tmux select-window -t '$pane' 2>/dev/null; tmux select-pane -t '$pane' 2>/dev/null"
  fi
  # Detached: terminal-notifier stays alive waiting for the click, but the hook
  # must NOT block the turn — background it and disown so we return instantly.
  terminal-notifier \
    -title "$title" -subtitle "$subtitle" -message "$body" \
    -execute "$click" -group "claude-${pane:-$project}" -sender com.mitchellh.ghostty \
    >/dev/null 2>&1 &
  disown 2>/dev/null
  exit 0
fi

# --- fallback: plain native banner (no click action) ---
esc() { printf '%s' "$1" | sed 's/"/\\"/g'; }
osascript -e "display notification \"$(esc "$body")\" with title \"$(esc "$title")\" subtitle \"$(esc "$subtitle")\""
exit 0
