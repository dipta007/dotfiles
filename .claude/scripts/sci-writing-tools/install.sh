#!/usr/bin/env bash
# NO_MCP=1 skips MCP registration; SKIP_BREW=1 skips system package installation.
set -euo pipefail

say()  { printf '\033[1;36m[sci-writing]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[sci-writing] WARN:\033[0m %s\n' "$*"; }
has()  { command -v "$1" >/dev/null 2>&1; }
OS="$(uname -s)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! has pandoc && [ -z "${SKIP_BREW:-}" ]; then
  if [ "$OS" = "Darwin" ] && has brew; then say "installing pandoc"; brew install pandoc || warn "pandoc install failed";
  elif has apt-get; then SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO="sudo"; say "apt pandoc"; $SUDO apt-get install -y pandoc >/dev/null 2>&1 || warn "pandoc apt failed";
  else warn "pandoc missing and no brew/apt; install it for mcp-pandoc PDF/docx"; fi
fi
has uv  || warn "uv not found; needed for Python tools and configuration"
has uvx || warn "uvx not found; needed for literature MCP servers"

if has uv; then
  say "ensuring Zotero semantic dependencies"
  uv tool install "zotero-mcp-server[semantic]==0.6.2" || warn "Zotero semantic installation failed"
  say "ensuring local Docling dependencies"
  uv tool install --python 3.12 "docling-mcp[local]==3.2.0" || warn "Docling installation failed"
fi

if [ ! -d "$HOME/.agents/skills/overleaf" ] && [ ! -d "$HOME/.claude/skills/overleaf" ]; then
  if has npx; then say "npx skills add aloth/olcli"; npx --yes skills add aloth/olcli >/dev/null 2>&1 || warn "olcli install failed"; fi
else say "olcli overleaf skill present"; fi

install_skill() {
  local name="$1" marketplace="$2" repository="$3" relative_path="$4"
  local root="$HOME/.claude/plugins/marketplaces/$marketplace"
  local source="$root/$relative_path" destination
  if [ ! -f "$source/SKILL.md" ]; then
    if [ -e "$root" ] || [ -L "$root" ]; then
      warn "missing $name in existing marketplace: $root"
      return
    fi
    if ! has git; then warn "git missing; cannot install $name"; return; fi
    mkdir -p "$(dirname "$root")"
    git clone --depth 1 "$repository" "$root" || { warn "could not fetch $marketplace"; return; }
  fi
  if [ ! -f "$source/SKILL.md" ]; then warn "missing skill: $source"; return; fi
  for destination in "$HOME/.agents/skills/$name" "$HOME/.claude/skills/$name"; do
    if [ -e "$destination" ] || [ -L "$destination" ]; then
      if [ ! -f "$destination/SKILL.md" ]; then warn "preserving invalid skill path: $destination"; fi
      continue
    fi
    mkdir -p "$(dirname "$destination")"
    ln -s "$source" "$destination"
    say "linked $destination"
  done
}

install_skill academic-plotting ai-research-skills https://github.com/orchestra-research/AI-research-SKILLs.git 20-ml-paper-writing/academic-plotting
install_skill drawio drawio https://github.com/jgraph/drawio-mcp.git plugins/claude-code/skills/drawio
install_skill paper-verification phd-skills https://github.com/fcakyon/phd-skills.git plugin/skills/paper-verification
install_skill reviewer-defense phd-skills https://github.com/fcakyon/phd-skills.git plugin/skills/reviewer-defense

SYNC="$SCRIPT_DIR/../sync-skills-to-codex.sh"
if [ -f "$SYNC" ]; then bash "$SYNC" || warn "skill synchronization failed"; fi

if has uv; then
  uv run --no-project --script "$SCRIPT_DIR/configure.py" || { warn "configuration failed; existing files were preserved where invalid"; exit 1; }
fi

say "restart installed harnesses to load configuration changes"
say "with Zotero running, index manually: zotero-mcp update-db --fulltext"
