# research-deck — ML/AI research presentation skill for Claude Code

A Claude Code skill that turns a paper / results into a storytelling deck
(**Problem → Gap → Method → Results → Takeaway**). It's the narrative + structure layer;
it drives Anthropic's `document-skills` **pptx** plugin for the actual `.pptx` file, and can
scaffold **Slidev/Marp** for HTML/PDF talks. Adapted from
[Gabberflast/academic-pptx-skill](https://github.com/Gabberflast/academic-pptx-skill) (MIT), ML-tuned.

## What's in here
- `SKILL.md` — workflow (asks minimal-vs-visual + pptx-vs-HTML each deck)
- `content_guidelines.md` — argument structure, action titles, ghost-deck test, ML QA checklist
- `figures.md` — matplotlib `text.usetex`, equation-as-image, real-figure scan (pptx has NO native LaTeX)
- `slide_patterns.md` — PptxGenJS coordinate patterns per ML slide type
- `install.sh` — idempotent bootstrap (all 3 layers below)

## The 3 layers you must reproduce on a new machine
Committing files alone is NOT enough — only layer A is files.

| Layer | What | How it's reproduced |
|---|---|---|
| **A. Skill files** | this directory | committed to dotfiles → symlinked/copied to `~/.claude/skills/research-deck` |
| **B. pptx plugin** | `document-skills@anthropic-agent-skills` marketplace+plugin registration | `install.sh` re-runs `claude plugin …` (idempotent) |
| **C. System deps** | node, pptxgenjs, LibreOffice, poppler, markitdown, (opt) LaTeX | `install.sh` via brew/apt/npm/uv |

## Install on a fresh machine
```bash
bash ~/path/to/dotfiles/claude/skills/research-deck/install.sh
```
Env flags: `LINK_MODE=copy` (default symlink) · `WITH_LATEX=1` (install TeX for true-LaTeX figures) ·
`SKILL_ONLY=1` (files+plugin only) · `NO_PLUGIN=1` (skip `claude plugin`, e.g. offline).

Works on macOS (Homebrew) and Debian/Ubuntu (apt). Re-running is safe.

## Wire into dotfiles

Recommended: keep the source-of-truth copy in your dotfiles repo and symlink it in.

**Plain dotfiles / bootstrap script** — add to your bootstrap:
```bash
bash "$DOTFILES/claude/skills/research-deck/install.sh"
```

**GNU stow** — put the tree at `stow/claude/.claude/skills/research-deck/`, then `stow claude`,
then once per machine run `install.sh SKILL_ONLY=1` isn't needed (stow made the symlink) — just run it to do layers B+C.

**chezmoi** — store files under `dot_claude/skills/research-deck/`, and add `install.sh` as a
`run_onchange_` script (chezmoi re-runs it when the file hashes change).

Note: `~/.claude/skills/` also holds other loose skills (`commit`, `explain`, …) — symlink the
`research-deck` *subdir* specifically; don't stow the whole `skills/` dir unless you track all of them.

## Verify after install
```bash
claude plugin list | grep document-skills          # layer B
command -v soffice pdftoppm node markitdown          # layer C (soffice may be in /Applications on mac)
ls ~/.claude/skills/research-deck                    # layer A
```
Then in Claude Code: *"make slides for my paper on X"* → the skill should trigger.
