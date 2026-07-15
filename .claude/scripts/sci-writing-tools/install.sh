#!/usr/bin/env bash
# Bootstrap scientific-writing tooling on a fresh machine (paper + docs tracks).
# MCP servers live in ~/.claude.json (NOT yadm-tracked), so they must be re-registered
# by this script rather than synced as files. Idempotent, check-first, never fails a pull.
#
#   zotero-mcp   two-way BibTeX / citations (paper track)   -> claude mcp: zotero
#   mcp-pandoc   markdown -> docx/pdf (docs track)           -> claude mcp: pandoc
#   olcli        Overleaf CLI + AgentSkill (paper track)     -> ~/.agents/skills/overleaf
#
# Usage: bash install.sh   (env: NO_MCP=1 skips claude mcp; SKIP_BREW=1 skips pandoc install)
set -euo pipefail

say()  { printf '\033[1;36m[sci-writing]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[sci-writing] WARN:\033[0m %s\n' "$*"; }
has()  { command -v "$1" >/dev/null 2>&1; }
OS="$(uname -s)"

# ---- system deps: pandoc (mcp-pandoc), uv/uvx, node/npx ----
if ! has pandoc && [ -z "${SKIP_BREW:-}" ]; then
  if [ "$OS" = "Darwin" ] && has brew; then say "installing pandoc"; brew install pandoc || warn "pandoc install failed";
  elif has apt-get; then SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO="sudo"; say "apt pandoc"; $SUDO apt-get install -y pandoc >/dev/null 2>&1 || warn "pandoc apt failed";
  else warn "pandoc missing and no brew/apt — install it for mcp-pandoc PDF/docx"; fi
fi
has uv  || warn "uv not found — needed for zotero-mcp install (astral.sh/uv)"
has uvx || warn "uvx not found — needed to run mcp-pandoc"

# ---- zotero-mcp: uv tool install + register with Claude Code ----
if ! has zotero-mcp; then
  if has uv; then say "uv tool install zotero-mcp-server"; uv tool install zotero-mcp-server >/dev/null 2>&1 || warn "zotero-mcp install failed"; fi
fi

# ---- olcli Overleaf AgentSkill (skips if already present) ----
if [ ! -d "$HOME/.agents/skills/overleaf" ] && [ ! -d "$HOME/.claude/skills/overleaf" ]; then
  if has npx; then say "npx skills add aloth/olcli"; npx --yes skills add aloth/olcli >/dev/null 2>&1 || warn "olcli install failed"; fi
else say "olcli overleaf skill present"; fi

# ---- register MCP servers with Claude Code (idempotent: skip if already listed) ----
if [ -z "${NO_MCP:-}" ]; then
  if has claude; then
    listed() { claude mcp list 2>/dev/null | grep -q "^$1:"; }
    if has zotero-mcp && ! listed zotero; then say "mcp add zotero"; claude mcp add --scope user zotero -- zotero-mcp serve >/dev/null 2>&1 || warn "zotero mcp add failed"; else say "zotero mcp present"; fi
    if has uvx && ! listed pandoc; then say "mcp add pandoc"; claude mcp add --scope user pandoc -- uvx mcp-pandoc >/dev/null 2>&1 || warn "pandoc mcp add failed"; else say "pandoc mcp present"; fi
  else warn "'claude' not on PATH — skipping mcp registration; re-run after installing Claude Code"; fi
else say "NO_MCP set — skipping mcp registration"; fi

say "done. Zotero MCP needs the Zotero desktop app running (local API) to answer queries."
