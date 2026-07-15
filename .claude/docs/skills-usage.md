# Claude Code Skills — Usage Reference

Personal cheat-sheet for the skills / plugins / MCP servers I've installed and how to use
each. Grows over time — add a new section per skill group using the template at the bottom.

**How skills are invoked:** mostly **natural language** — describe the task and the skill
auto-fires on matching phrases. Exceptions: `/name` slash commands, and MCP servers (the
model calls those as tools automatically when a task needs them).

> New plugins load at Claude Code **session start** — restart once after installing.
> Plain skills dropped in `~/.claude/skills/` and MCP servers are picked up live.

Quick management commands (any skill group):
```bash
claude plugin list                     # installed plugins
claude plugin details <name>           # inventory + token cost
claude plugin uninstall <name>@<mktpl>
claude mcp list                        # MCP server health
claude mcp remove --scope user <name>
npx skills@latest remove <skill> -g    # skills installed via Vercel skills CLI
```

---

# ML Research (installed 2026-07-14)

**Group inventory**
- `phd-skills` (plugin, `fcakyon/phd-skills`) — 12 skills + 2 agents + 6 slash commands
- `ideation` (plugin, Orchestra `orchestra-research/AI-research-SKILLs`, 1 of 23 categories) — 2 skills
- `wandb-primary` (official W&B skill, via `npx skills add wandb/skills`) — 1 skill
- `semantic-scholar` + `arxiv` (MCP servers, via `uvx`) — live paper data

### Research ideation
| Skill / command | Use it for | Example |
|---|---|---|
| `brainstorming-research-ideas` (Orchestra) | High-impact directions | "Brainstorm new directions on credit assignment in long multi-turn RL rollouts." |
| `creative-thinking-for-research` (Orchestra) | Novel angles via analogy | "Give me novel angles on reward shaping by analogy to other fields." |
| `literature-research` (phd-skills) | Related work / survey / find implementations | "Find related work on online hint generation for RL agents." |
| `/gaps <topic>` (phd-skills) | Gap analysis w/ web confirmation | `/gaps teacher-guided exploration in agentic GRPO` |

### Critical thinking / stress-testing
| Skill | Use it for | Example |
|---|---|---|
| `socratic` (custom, dotfiles) | Adversarial interrogation of an idea — assumptions, evidence, devil's advocate, confounds, novelty vs real literature (uses arxiv + semantic-scholar MCPs). Anti-sycophantic. | "Socratic: poke holes in my hypothesis that nudging helps weak models more than strong ones." |

### Experiment output analysis & insight
| Skill / agent | Use it for | Example |
|---|---|---|
| `experiment-analyzer` (agent) | Interpret results/logs | "Use experiment-analyzer on these two runs' reward+entropy curves — why does v8 plateau?" |
| `compare` (phd-skills) | Same-epoch run comparison (wandb/neptune/tb/mlflow) | "Compare my shaped vs terminal reward runs at the same step." |
| `debug` (phd-skills) | Evidence-first diagnosis of a failing run | "Training diverged ~step 120 — debug it, don't guess." |
| `wandb-primary` (W&B) | Project overview, runs/artifacts, Weave, Reports | "Summarize last 5 runs' success rate in collab-srd/amazon26." (needs WANDB_API_KEY) |

### Paper writing & pre-submission (phd-skills bonus)
| Skill / command | Use it for | Example |
|---|---|---|
| `experiment-design` | Plan ablations / baselines | "Design the ablation set for the nudging paper." |
| `paper-writing` | Draft/structure sections, notation | "Structure the methods section." |
| `paper-verification` | Verify claims vs code/numbers | "Check Table 2's numbers against the logs." |
| `/xray` | 5-agent full paper audit | `/xray` (in a paper repo) |
| `/factcheck` | Verify BibTeX + claims vs DBLP/web | `/factcheck` |
| `/fortify <venue>` | Strongest ablations + reviewer prep | `/fortify NeurIPS` |
| `reviewer-defense` | Rebuttals, find weaknesses | "What will reviewers attack here?" |
| `reproduce` | Reproduce a paper from arxiv URL | "Reproduce arxiv.org/abs/XXXX.XXXXX" |
| `research-publishing` | Prep code for release | "Prep this repo for open-source release." |
| `dataset-curation` | Bias / imbalance / stratified sampling | "Analyze class imbalance in this dataset." |
| `latex-setup` | Set up/troubleshoot LaTeX for a venue | "Set up LaTeX for the ICML template." |
| `/setup`, `/help` | phd-skills config tour / feature list | `/help` |

### Literature data layer (MCP — auto-invoked, not called directly)
- **semantic-scholar** — search w/ filters, citation/reference graph, author h-index, PDF->md, SPECTER semantic search.
- **arxiv** — search / download / read arxiv papers.
> Example: "Search Semantic Scholar for most-cited GRPO papers since 2024 and show the citation graph."

**"Which do I use?"** find direction -> `brainstorming-research-ideas` · find the gap -> `/gaps`
· survey -> `literature-research` + MCPs · understand results -> `experiment-analyzer`/`compare`
· why broke -> `debug` · wandb -> `wandb-primary` · write/audit paper -> `paper-writing`/`/xray`/`/factcheck`

**Reinstall on new machine**
- phd-skills + ideation + wandb-primary -> in dotfiles (`.claude/settings.json` + `.claude/skills/wandb-primary/`), restored by `yadm clone`.
- MCP servers -> `yadm bootstrap` (`setup_claude_mcp`), or manually:
  ```bash
  claude mcp add --scope user semantic-scholar -- uvx semantic-scholar-mcp
  claude mcp add --scope user arxiv -- uvx arxiv-mcp-server
  ```

---

# Scientific writing — papers + collaboration docs (installed 2026-07-15)

**Group inventory**
- `phd-skills` (plugin, installed earlier) — PAPER-track engine: `/factcheck` (BibTeX vs DBLP), `/xray` (5-agent audit), `/fortify`, paper-writing/verification skills, auto-`pdflatex` + citation-guard hooks, venue templates (NeurIPS/ICML/ICLR/ACL/CVPR)
- `document-skills` docx (plugin, installed earlier) — DOCS engine: real Word tracked-changes + threaded comments, all headless/CLI
- `zotero-mcp` (MCP, `54yyyu/zotero-mcp`) — two-way BibTeX + Better-BibTeX key lookup. **Needs the Zotero desktop app running.**
- `pandoc` (MCP, `vivekVells/mcp-pandoc`) — markdown ⇄ docx/pdf/… with house-style Word reference doc
- `overleaf` (AgentSkill, `aloth/olcli`) — pull/push/sync/**remote-compile** Overleaf projects from the terminal

### Papers (LaTeX)
| Trigger phrase | What happens | Example |
|---|---|---|
| "check my citations / BibTeX" | phd-skills `/factcheck` verifies author/venue/year/numbers vs DBLP | `/phd-skills:factcheck` |
| "audit my paper" | phd-skills `/xray` — 5 parallel agents (numbers/terms/code/cites/eval) | `/phd-skills:xray` |
| "add this paper to my refs" | zotero-mcp imports BibTeX / looks up by citation key | "Add the DeepSeekMath BibTeX to refs.bib" |
| "pull / compile my Overleaf project" | overleaf skill syncs + compiles PDF remotely | "Pull my Overleaf project and compile it" |

### Docs (collaboration)
| Trigger phrase | What happens | Example |
|---|---|---|
| "make a Word doc with tracked changes / comments" | document-skills docx (w:ins/w:del + comment.py) | "Turn this into a .docx with my edits as tracked changes" |
| "convert this markdown to Word/PDF" | pandoc MCP, optional reference doc for house style | "Convert notes.md to a styled .docx" |

**Reminder:** raw LLM BibTeX is ~51% fully-correct — always run `/factcheck` before submitting. Avoid (refuted/unmaintained): claude-scientific-writer for LaTeX, Yeok-c/latex-mcp-server, overleaf-forge, ClaudePrism (GUI), texlab (editor LSP).

**Reinstall on new machine**
- phd-skills + document-skills → dotfiles (restored by `yadm clone`).
- zotero-mcp + pandoc + overleaf → `post_pull` auto-runs `~/.claude/scripts/sci-writing-tools/install.sh` (idempotent); or manually:
  ```bash
  bash ~/.claude/scripts/sci-writing-tools/install.sh
  ```

---

# Presentations / Slide decks (installed 2026-07-14)

**Group inventory**
- `research-deck` (skill, `~/.claude/skills/research-deck/`) — ML-research deck narrative + design layer (self-contained; SKILL.md + content_guidelines + slide_patterns + figures + install.sh)
- `document-skills` (plugin, `anthropics/skills` marketplace) — Anthropic's pptx/docx/xlsx/pdf; `research-deck` drives its **pptx** skill for the actual file
- Slidev + Marp CLI (`npm -g`) — HTML/PDF decks with native KaTeX math + code line-stepping
- toolchain: pptxgenjs, markitdown, LibreOffice, poppler, matplotlib (installed by `research-deck/install.sh`)

### Make a deck
| Trigger phrase | What happens | Example |
|---|---|---|
| "make slides for my paper on X" | `research-deck` fires: asks pptx-vs-HTML + where results are, plans Problem→Gap→Method→Results→Takeaway, builds + QA | "Make slides from weekly_july14.md" |
| "conference talk / thesis defense / reading-group slides" | same skill, sets slide budget from talk length | "12-min ICML talk from this paper" |
| "present these results" (+ a CSV / table / wandb runs) | recreates the figure the story needs (white, annotated), never embeds as-is | "Present v141 vs v142 convergence from wandb" |

**Defaults baked in (no need to ask for them):** white minimal academic bg (never dark); action titles (ghost-deck test); one exhibit/results slide; **body 20pt, 18pt floor**; ends on Conclusions; built-in visual QA (render → subagent inspects).

### Behavior worth knowing
- **Figures are recreated for the story** — hand it a figure/CSV/table/prompt-numbers/wandb; it re-plots the exhibit the narrative needs. Never invents numbers.
- **wandb** via the `wandb-primary` skill — it asks for entity/project/runs/metrics + API key if unset.
- **Two output tracks:** editable `.pptx` (co-authors, templates) or Slidev/Marp HTML/PDF (self-presented, real LaTeX). Ask which.

**"Which do I use?"** editable deck for co-authors → pptx track · math/code talk I present → Slidev · quick handout → Marp `--pptx`.

**Reinstall on new machine**
- `research-deck` skill → in dotfiles (`.claude/skills/research-deck/`), restored by `yadm clone`.
- plugin + toolchain → `post_pull` hook auto-runs `research-deck/install.sh` (idempotent); or manually:
  ```bash
  bash ~/.claude/skills/research-deck/install.sh          # plugin + node/pptxgenjs/markitdown/LibreOffice/poppler
  npm i -g @slidev/cli @marp-team/marp-cli                # HTML track (optional)
  ```

---

<!-- ===== TEMPLATE: copy this block to document a new skill group =====

# <Group name> (installed YYYY-MM-DD)

**Group inventory**
- `<name>` (<plugin | skill | MCP>, `<source>`) — <what it is>

### <Sub-area>
| Skill / command | Use it for | Example |
|---|---|---|
| `<name>` | <purpose> | "<natural-language example>" |

**Reinstall:** <dotfiles path or install command>

===================================================================== -->
