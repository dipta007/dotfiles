#!/bin/bash
# tmux-resurrect post-save-all hook. Snapshots which panes have a live Claude
# session so resurrect_postrestore.sh can resume them after reboot.
# Key by pane POSITION (session:window.pane), because pane-ids (%N) are NOT stable
# across a tmux server restart but positions are restored by resurrect.
# Pure bash -> portable Mac/Linux.

dir="$HOME/.claude/agent-resume"
panes_dir="$dir/panes"
out="$dir/restore.tsv"
mkdir -p "$dir"
: > "$out"

[ -d "$panes_dir" ] || exit 0

# For each live pane, if it has a marker (a claude session), record position+sid+cwd.
tmux list-panes -a -F '#{pane_id} #{session_name}:#{window_index}.#{pane_index}' 2>/dev/null | \
while read -r pane_id position; do
  key="$(printf '%s' "$pane_id" | tr -d '%')"
  marker="$panes_dir/$key"
  [ -f "$marker" ] || continue
  IFS=$'\t' read -r sid cwd < "$marker"
  [ -n "$sid" ] || continue
  # position<TAB>session_id<TAB>cwd
  printf '%s\t%s\t%s\n' "$position" "$sid" "$cwd" >> "$out"
done

exit 0
