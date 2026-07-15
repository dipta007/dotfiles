#!/usr/bin/env bash
# Bootstrap the research-deck skill on a fresh machine.
# Reproduces all 3 layers: (A) skill files, (B) document-skills plugin, (C) system deps.
# Idempotent — safe to re-run. Designed to be called from a dotfiles bootstrap.
#
# Usage:
#   bash install.sh                 # link skill + install plugin + tools + system deps
#   LINK_MODE=copy bash install.sh  # copy skill files instead of symlinking
#   WITH_LATEX=1 bash install.sh    # also install a LaTeX distro (for text.usetex figures; heavy)
#   SKILL_ONLY=1 bash install.sh    # only link skill files + install plugin; skip system/tool deps
#   NO_PLUGIN=1 bash install.sh     # skip the `claude plugin` step (offline / no claude on PATH)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/.claude/skills/research-deck"
LINK_MODE="${LINK_MODE:-symlink}"   # symlink | copy
OS="$(uname -s)"

say()  { printf '\033[1;34m[research-deck]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[research-deck] WARN:\033[0m %s\n' "$*"; }
has()  { command -v "$1" >/dev/null 2>&1; }

# ── Layer A: place the skill files ───────────────────────────────────────────
place_skill() {
  mkdir -p "$HOME/.claude/skills"
  # If we're already the destination, nothing to do (running in place).
  if [ "$SCRIPT_DIR" = "$DEST" ]; then say "skill already in place ($DEST)"; return; fi
  if [ "$LINK_MODE" = "copy" ]; then
    rm -rf "$DEST"; cp -R "$SCRIPT_DIR" "$DEST"; say "copied skill → $DEST"
  else
    rm -rf "$DEST"; ln -s "$SCRIPT_DIR" "$DEST"; say "symlinked $SCRIPT_DIR → $DEST"
  fi
}

# ── Layer B: the document-skills plugin (pptx/docx/xlsx/pdf) ──────────────────
install_plugin() {
  [ -n "${NO_PLUGIN:-}" ] && { say "NO_PLUGIN set — skipping plugin"; return; }
  if ! has claude; then warn "'claude' not on PATH — skipping plugin; re-run after installing Claude Code"; return; fi
  # Check-first: the add/install do network git fetches, so skip them entirely when
  # already present. Keeps the every-pull post_pull path fast.
  if claude plugin list 2>/dev/null | grep -q document-skills; then say "document-skills plugin present"; return; fi
  say "installing document-skills plugin"
  claude plugin marketplace add anthropics/skills             >/dev/null 2>&1 || true
  claude plugin install document-skills@anthropic-agent-skills >/dev/null 2>&1 || true
  claude plugin list 2>/dev/null | grep -q document-skills \
    && say "document-skills plugin installed" \
    || warn "document-skills not confirmed — run manually: claude plugin install document-skills@anthropic-agent-skills"
}

# ── Layer C: system + tool deps ───────────────────────────────────────────────
soffice_present() { has soffice || [ -x /Applications/LibreOffice.app/Contents/MacOS/soffice ]; }

install_system() {
  [ -n "${SKILL_ONLY:-}" ] && { say "SKILL_ONLY set — skipping system/tool deps"; return; }

  # Fast path: if everything's already here, don't shell out to brew/apt/npm at all.
  # (WITH_LATEX still forces the slow path when latex is missing.)
  if soffice_present && has pdftoppm && has node && npm ls -g pptxgenjs >/dev/null 2>&1 \
     && has markitdown && { [ -z "${WITH_LATEX:-}" ] || has latex; }; then
    say "system + tool deps already present"; return
  fi

  # OS package deps: LibreOffice (visual QA render) + poppler (pdf→img). node for pptxgenjs.
  if [ "$OS" = "Darwin" ]; then
    if has brew; then
      soffice_present || { say "installing libreoffice"; brew install --cask libreoffice || warn "libreoffice install failed"; }
      has pdftoppm || { say "installing poppler"; brew install poppler || warn "poppler install failed"; }
      has node     || { say "installing node";    brew install node    || warn "node install failed"; }
      [ -n "${WITH_LATEX:-}" ] && ! has latex && { say "installing mactex-no-gui (large)"; brew install --cask mactex-no-gui || warn "latex install failed"; }
    else
      warn "Homebrew not found — install brew, or manually: libreoffice, poppler, node"
    fi
  elif [ "$OS" = "Linux" ]; then
    if has apt-get; then
      local SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO="sudo"
      say "apt-get: libreoffice-impress poppler-utils"
      $SUDO apt-get update -qq || warn "apt update failed"
      $SUDO apt-get install -y --no-install-recommends libreoffice-impress poppler-utils >/dev/null 2>&1 || warn "apt install failed (no sudo? pods may lack visual-QA)"
      [ -n "${WITH_LATEX:-}" ] && $SUDO apt-get install -y --no-install-recommends texlive-latex-extra dvipng >/dev/null 2>&1 || true
      has node || warn "node not found — install via nvm/apt for pptxgenjs"
    else
      warn "no apt-get — install libreoffice + poppler + node via your package manager"
    fi
  else
    warn "unknown OS '$OS' — install libreoffice, poppler, node manually"
  fi

  # pptxgenjs (create .pptx from scratch)
  if has npm; then
    npm ls -g pptxgenjs >/dev/null 2>&1 || { say "npm i -g pptxgenjs"; npm install -g pptxgenjs >/dev/null 2>&1 || warn "pptxgenjs install failed"; }
  else
    warn "npm not found — install node, then: npm i -g pptxgenjs"
  fi

  # markitdown (content QA). Prefer uv, fall back to pipx/pip.
  if ! has markitdown; then
    if has uv;   then say "uv tool install markitdown"; uv tool install "markitdown[pptx]" >/dev/null 2>&1 || warn "markitdown via uv failed";
    elif has pipx; then pipx install "markitdown[pptx]" >/dev/null 2>&1 || warn "markitdown via pipx failed";
    else warn "no uv/pipx — install: uv tool install 'markitdown[pptx]'"; fi
  fi
}

say "OS=$OS  LINK_MODE=$LINK_MODE  WITH_LATEX=${WITH_LATEX:-0}  SKILL_ONLY=${SKILL_ONLY:-0}"
place_skill
install_plugin
install_system
say "done. Optional HTML track: npm i -g @marp-team/marp-cli @slidev/cli"
