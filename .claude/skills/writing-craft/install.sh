#!/usr/bin/env bash
# writing-craft skill: pure-markdown, zero dependencies. yadm tracks the files directly and
# they already live at ~/.claude/skills/writing-craft/, so there's nothing to install.
# This stub exists only so a dotfiles bootstrap can call it uniformly alongside the other skills.
set -euo pipefail
DEST="$HOME/.claude/skills/writing-craft"
if [ -d "$DEST" ] && [ -f "$DEST/SKILL.md" ]; then
  printf '\033[1;35m[writing-craft]\033[0m skill present at %s (no deps to install)\n' "$DEST"
else
  printf '\033[1;33m[writing-craft] WARN:\033[0m %s missing — expected yadm to have placed it\n' "$DEST"
fi
