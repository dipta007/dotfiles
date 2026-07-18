#!/bin/bash
# Claude Code SessionStart(compact) hook: re-inject working state after context compaction
# so long sessions don't lose track of where they are.
# Reads SessionStart JSON payload on stdin (.cwd). Emits additionalContext JSON via jq
# (jq handles all newline/quote escaping). Uses $HOME — portable across synced machines.

payload="$(cat)"
cwd="$(printf '%s' "$payload" | jq -r '.cwd // empty' 2>/dev/null)"
[ -z "$cwd" ] && cwd="$PWD"

ctx="Session state re-injected after compaction:
Working directory: $cwd"

if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch="$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)"
  ctx="$ctx
Git branch: $branch"

  status="$(git -C "$cwd" status --short 2>/dev/null)"
  if [ -n "$status" ]; then
    ctx="$ctx
Uncommitted changes:
$status"
  else
    ctx="$ctx
Working tree clean"
  fi

  log="$(git -C "$cwd" log --oneline -5 2>/dev/null)"
  if [ -n "$log" ]; then
    ctx="$ctx
Recent commits:
$log"
  fi
fi

jq -n --arg ctx "$ctx" \
  '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $ctx}}'
exit 0
