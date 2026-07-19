#!/bin/bash
# tmux-resurrect post-restore-all hook. Re-launches `claude --resume <id>` in each
# pane that had a live Claude session before the reboot (recorded by resurrect_presave.sh).
# Matches by pane POSITION (session:window.pane), which resurrect restores.
# Cross-platform: finds the claude binary via a fallback chain (Mac ASBX / Linux).

restore="$HOME/.claude/agent-resume/restore.tsv"
[ -f "$restore" ] || exit 0

# Locate a claude binary that works on this machine.
claude_bin=""
for c in "$(command -v claude 2>/dev/null)" \
         "$HOME/.toolbox/bin/claude" \
         "$HOME/.local/bin/claude" \
         "$HOME/.claude/local/claude" \
         "/opt/homebrew/bin/claude" \
         "/usr/local/bin/claude"; do
  if [ -n "$c" ] && [ -x "$c" ]; then claude_bin="$c"; break; fi
done
[ -n "$claude_bin" ] || exit 0   # no claude here (e.g. a box without it) -> do nothing

while IFS=$'\t' read -r position sid cwd; do
  [ -n "$position" ] && [ -n "$sid" ] || continue
  # pane must exist at that position after restore
  tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}' 2>/dev/null \
    | grep -qxF "$position" || continue
  # don't clobber a pane that already has claude running (continuum double-restore)
  cur="$(tmux display-message -p -t "$position" '#{pane_current_command}' 2>/dev/null)"
  case "$cur" in claude|*claude*) continue ;; esac
  # resume: cd to the session's dir, then exec claude --resume. reset clears restored scrollback.
  tmux respawn-pane -k -t "$position" \
    "sh -c 'cd \"$cwd\" 2>/dev/null; reset; exec \"$claude_bin\" --resume \"$sid\"'" 2>/dev/null
done < "$restore"

exit 0
