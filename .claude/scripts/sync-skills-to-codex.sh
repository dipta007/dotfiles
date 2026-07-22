#!/usr/bin/env bash
# Sync Claude skills -> Codex via per-folder symlinks.
# Source of truth: ~/.claude/skills. Codex reads each skill through a symlink.
# Add/remove a skill in Claude, run this (or launch codex via the wrapper), done.
#
# Safe by design:
#  - never touches ~/.codex/skills/.system (Codex's own bundled skills)
#  - only removes symlinks it owns (links pointing back into ~/.claude or ~/.agents)
#  - resolves nested symlinks (e.g. overleaf -> ~/.agents/skills/overleaf) to real path
set -euo pipefail

CLAUDE_SKILLS="$HOME/.claude/skills"
CODEX_SKILLS="$HOME/.codex/skills"

[ -d "$CLAUDE_SKILLS" ] || { echo "no $CLAUDE_SKILLS"; exit 1; }
mkdir -p "$CODEX_SKILLS"

linked=0
# Link every Claude skill folder into Codex.
for src in "$CLAUDE_SKILLS"/*; do
  [ -e "$src" ] || continue          # empty glob guard
  name=$(basename "$src")
  case "$name" in .*) continue;; esac # skip dotfiles
  # resolve real dir (follows symlinks like overleaf -> ~/.agents/skills/overleaf)
  real=$(cd "$src" 2>/dev/null && pwd -P) || continue
  [ -f "$real/SKILL.md" ] || continue # only real skills
  dest="$CODEX_SKILLS/$name"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$real" ]; then
    :                                 # already correct
  else
    rm -rf "$dest"
    ln -s "$real" "$dest"
  fi
  linked=$((linked+1))
done

# Remove stale links we own: symlinks in Codex pointing into ~/.claude or ~/.agents
# whose Claude source no longer exists.
pruned=0
for dest in "$CODEX_SKILLS"/*; do
  [ -L "$dest" ] || continue
  tgt=$(readlink "$dest")
  case "$tgt" in
    "$HOME/.claude/"*|"$HOME/.agents/"*)
      if [ ! -e "$dest" ] || [ ! -e "$CLAUDE_SKILLS/$(basename "$dest")" ]; then
        rm -f "$dest"; pruned=$((pruned+1))
      fi;;
  esac
done

echo "synced $linked skill(s) into $CODEX_SKILLS (pruned $pruned stale link(s))"
