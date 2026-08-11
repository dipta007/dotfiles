#!/bin/bash
# Claude Code notification hook. Arg $1 = event: "done" or "input".
# Reads Stop/Notification JSON payload on stdin (.cwd, .transcript_path, .message).
# Banner (no sound):
#   title    = 🖥️ session - window (tmux), else 🖥️ project
#   subtitle = 📁 project @ git-branch
#   body     = Claude's actual last message/question (rich), else fallback
#              ✅ Task complete / 🚨 Needs your input
# Click-to-focus: with terminal-notifier, clicking activates Ghostty and jumps
# tmux to the exact pane that fired. Falls back to a plain osascript banner on
# machines without terminal-notifier. Uses $HOME — portable across synced PCs.

event="${1:-done}"

payload="$(cat)"
cwd="$(printf '%s' "$payload" | jq -r '.cwd // empty' 2>/dev/null)"
[ -z "$cwd" ] && cwd="$PWD"
transcript="$(printf '%s' "$payload" | jq -r '.transcript_path // empty' 2>/dev/null)"
notif_msg="$(printf '%s' "$payload" | jq -r '.message // empty' 2>/dev/null)"

project="$(basename "$cwd")"
sess="$(tmux display-message -p '#S' 2>/dev/null)"   # tmux session, empty if none
win="$(tmux display-message -p '#W' 2>/dev/null)"    # tmux window name
pane="${TMUX_PANE:-$(tmux display-message -p '#{pane_id}' 2>/dev/null)}"  # stable pane id
branch="$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)"

# title / subtitle
if [ -n "$sess" ]; then title="🖥️ $sess - $win"; else title="🖥️ $project"; fi
subtitle="📁 $project"; [ -n "$branch" ] && subtitle="$subtitle @ $branch"

# generic fallback body per event (used for phone push, and desktop when no rich text)
case "$event" in
  input) generic="🚨 Needs your input" ;;
  *)     generic="✅ Task complete" ;;
esac

# rich desktop body = Claude's actual words.
#  - input: Claude Code puts its question in stdin .message → use it.
#  - done:  reverse-scan the transcript tail for the newest assistant text block.
# Both trimmed to one line ≤140 chars. Any miss → generic fallback.
rich=""
if [ "$event" = "input" ] && [ -n "$notif_msg" ]; then
  rich="$notif_msg"
elif [ -n "$transcript" ] && [ -f "$transcript" ]; then
  # tail 64KB (last assistant msg is near the end), newest-first, skip subagent
  # (isSidechain) turns and non-text (thinking/tool_use) blocks. First hit wins.
  # tail -r reverses lines (macOS; no `tac`). tac used when present (Linux).
  # gsub collapses whitespace INSIDE jq so a multi-line message stays one line —
  # else jq -r's real newlines would let `head -1` truncate it mid-message.
  if command -v tac >/dev/null 2>&1; then rev=tac; else rev="tail -r"; fi
  rich="$(tail -c 65536 "$transcript" 2>/dev/null | $rev 2>/dev/null | jq -rc '
    select(.type=="assistant" and (.isSidechain|not))
    | .message.content[]? | select(.type=="text") | .text | gsub("\\s+";" ")' 2>/dev/null \
    | head -1)"
fi
# collapse whitespace/newlines to single spaces, trim, cap length
if [ -n "$rich" ]; then
  rich="$(printf '%s' "$rich" | tr '\n\r\t' '   ' | sed -E 's/  +/ /g; s/^ +//; s/ +$//')"
  [ "${#rich}" -gt 140 ] && rich="${rich:0:139}…"
fi
body="${rich:-$generic}"

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
  group="claude-${pane:-$project}"
  # -execute makes terminal-notifier stay alive waiting for a click, so each
  # notification leaks a process that never exits. Two guards stop the pile-up:
  # 1) kill this group's prior notifier. a new -group already replaces the
  #    visible banner, so the old process is dead weight (max 1 per pane).
  pkill -f "terminal-notifier.*-group $group" 2>/dev/null
  # Detached + disowned so the hook returns instantly (must NOT block the turn).
  terminal-notifier \
    -title "$title" -subtitle "$subtitle" -message "$body" \
    -execute "$click" -group "$group" -sender com.mitchellh.ghostty \
    >/dev/null 2>&1 &
  tn_pid=$!
  disown 2>/dev/null
  # 2) watchdog: reap this notifier after 5 min if still waiting for a click.
  #    click-to-focus works for 5 min; after that a stale notif isn't worth a leak.
  ( sleep 300; kill "$tn_pid" 2>/dev/null ) >/dev/null 2>&1 &
  disown 2>/dev/null
  exit 0
fi

# --- fallback: plain native banner (no click action) ---
esc() { printf '%s' "$1" | sed 's/"/\\"/g'; }
osascript -e "display notification \"$(esc "$body")\" with title \"$(esc "$title")\" subtitle \"$(esc "$subtitle")\""
exit 0
