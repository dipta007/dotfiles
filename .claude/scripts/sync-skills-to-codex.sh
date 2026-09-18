#!/usr/bin/env bash
# Real directories and links outside the shared skill roots belong to the user.
set -euo pipefail

CLAUDE_SKILLS="$HOME/.claude/skills"
SHARED_SKILLS="$HOME/.agents/skills"
CODEX_SKILLS="$HOME/.codex/skills"

[ -d "$CLAUDE_SKILLS" ] || [ -d "$SHARED_SKILLS" ] || { echo "no shared skills"; exit 1; }
mkdir -p "$CODEX_SKILLS"

linked=0
for src in "$CLAUDE_SKILLS"/* "$SHARED_SKILLS"/*; do
  [ -e "$src" ] || continue
  name=$(basename "$src")
  case "$name" in .*) continue;; esac
  if [ "$src" = "$SHARED_SKILLS/$name" ] && [ -f "$CLAUDE_SKILLS/$name/SKILL.md" ]; then continue; fi
  real=$(cd "$src" 2>/dev/null && pwd -P) || continue
  [ -f "$real/SKILL.md" ] || continue
  dest="$CODEX_SKILLS/$name"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$real" ]; then
    :
  else
    if [ -L "$dest" ]; then
      case "$(readlink "$dest")" in
        "$HOME/.claude/"*|"$HOME/.agents/"*) rm "$dest";;
        *) echo "preserving custom skill link: $dest"; continue;;
      esac
    elif [ -e "$dest" ]; then
      echo "preserving custom skill: $dest"
      continue
    fi
    ln -s "$real" "$dest"
  fi
  linked=$((linked+1))
done

pruned=0
for dest in "$CODEX_SKILLS"/*; do
  [ -L "$dest" ] || continue
  tgt=$(readlink "$dest")
  case "$tgt" in
    "$HOME/.claude/"*|"$HOME/.agents/"*)
      name=$(basename "$dest")
      if [ ! -e "$dest" ] || { [ ! -f "$CLAUDE_SKILLS/$name/SKILL.md" ] && [ ! -f "$SHARED_SKILLS/$name/SKILL.md" ]; }; then
        rm -f "$dest"; pruned=$((pruned+1))
      fi;;
  esac
done

echo "synced $linked skill(s) into $CODEX_SKILLS (pruned $pruned stale link(s))"
