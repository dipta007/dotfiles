#!/bin/bash
# Claude SessionStart/SessionEnd hook. Arg $1 = "start" | "end".
# Records the Claude session_id + cwd for the current tmux pane so the pane can be
# resumed after a reboot (paired with resurrect_presave.sh / resurrect_postrestore.sh).
# No-op outside tmux. Pure bash + jq -> portable Mac/Linux. Data is machine-local.

[ -n "$TMUX_PANE" ] || exit 0   # only meaningful inside tmux

action="${1:-start}"
dir="$HOME/.claude/agent-resume/panes"
mkdir -p "$dir"

# pane id like %227 -> filename-safe 227
pane_key="$(printf '%s' "$TMUX_PANE" | tr -d '%')"
marker="$dir/$pane_key"

if [ "$action" = "end" ]; then
  rm -f "$marker"
  exit 0
fi

payload="$(cat)"
sid="$(printf '%s' "$payload" | jq -r '.session_id // empty' 2>/dev/null)"
cwd="$(printf '%s' "$payload" | jq -r '.cwd // empty' 2>/dev/null)"
[ -z "$cwd" ] && cwd="$PWD"
[ -n "$sid" ] || exit 0

# marker: session_id<TAB>cwd  (one pane = one live claude session)
printf '%s\t%s\n' "$sid" "$cwd" > "$marker"
exit 0
