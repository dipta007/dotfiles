---
name: research-deck
description: "Use this skill whenever the user wants to create or improve a slide deck / presentation for MACHINE-LEARNING or AI research — paper talks, conference presentations (NeurIPS/ICML/ICLR/ACL/CVPR style), seminar/reading-group slides, thesis or proposal defenses, lab meetings, poster talks, or any deck where the audience evaluates a method and its results. Triggers: 'make slides for my paper', 'conference talk', 'research presentation', 'ML deck', 'thesis defense', 'reading group slides', 'present these results', or a .pptx filename in a research context. This skill governs CONTENT, ARGUMENT STRUCTURE, and NARRATIVE (the what/why/how/results arc). For the technical work of writing the .pptx file, it drives the installed `pptx` skill. Adapted from Gabberflast/academic-pptx-skill (MIT), ML-tuned."
license: MIT
---

# Research Deck Skill (ML/AI)

Turn a paper, a set of results, or a rough idea into a deck that tells a clear
**what / why / how / results** story an ML researcher can follow. This skill is the
NARRATIVE + STRUCTURE layer. It sits on top of the `pptx` skill, which does the file work.

## How this skill works

Three layers, read in order:

1. **This file** — the workflow: pick aesthetic mode, plan the argument, wire to pptx, QA.
2. **[content_guidelines.md](content_guidelines.md)** — argument structure, action titles, exhibit discipline, deck architecture for an ML talk.
3. **[slide_patterns.md](slide_patterns.md)** — PptxGenJS coordinate patterns per ML slide type (title, motivation, method, results, ablation, conclusions, …).
4. **[figures.md](figures.md)** — getting ML figures onto slides: matplotlib `text.usetex` for true-LaTeX plots, the figure-attach protocol, equations-as-images (the pptx skill has NO native LaTeX).

**Always read content_guidelines.md AND the pptx skill's SKILL.md before writing any code.**
For editable-.pptx output, also read the pptx skill's `pptxgenjs.md` (create) or `editing.md` (from template).

---

## Step 0 — Ask two things up front (do NOT skip)

Before planning slides, ask the user (unless they already told you):

**(a) Aesthetic mode** — this skill never assumes; ask every deck:
> "Two looks: **minimal** (white bg, one sans font, ≤3 colors, no icons — the clean conference/paper standard) or **visual** (same narrative rigor, but architecture diagrams, colored callouts, tasteful accents for engagement). Which for this deck?"

- **minimal** → apply the communication-first design rules below. These OVERRIDE the pptx skill's design-forward defaults.
- **visual** → keep ALL narrative rules (action titles, one-exhibit, ghost-deck test) but allow the pptx skill's richer visual palette, diagrams, and accents. Never let visuals add words or bury the finding.

**(b) Output track:**
> "Editable **.pptx** (co-authors can edit, matches a lab/venue template) or **HTML/PDF** you present yourself?"

- **.pptx** → drive the `pptx` skill (create-from-scratch via pptxgenjs, or edit-from-template).
- **HTML/PDF, math/code-heavy talk** → you MAY instead scaffold a **Slidev** or **Marp** deck (native LaTeX via KaTeX/MathJax, code line-stepping). Still apply this skill's narrative structure. Only do this if the user is fine without an editable .pptx.

Also collect: talk length (sets slide budget), venue/template if any, and where the figures live.

---

## Step 1 — Plan the argument BEFORE any slide

Default narrative spine for ML research: **Problem → Gap → Method → Results → Takeaway**
(this is Situation/Complication/Resolution, ML-flavored). Use answer-first (headline result up front)
only if the user asks or the talk is short / for a senior audience.

Produce a slide-by-slide outline: for each slide give the **action title** (a full sentence stating
the takeaway) and the **exhibit type** (chart / table / diagram / equation / none). Confirm the outline
with the user if the deck is >10 slides or the content is complex. Do not build until it's agreed.

**Ghost-deck test (mandatory):** read ONLY the action titles in sequence. They must tell the whole
story on their own. If they don't, fix the outline before building. See content_guidelines.md §2.

---

## Step 2 — Design rules for MINIMAL mode

(Skip if the user chose visual mode; then follow the pptx skill's design guidance instead, keeping narrative rules.)

- **Background** white for content slides; dark navy for title + conclusions only (sandwich).
- **Font**: one sans-serif throughout (Arial/Calibri/Helvetica, or the venue template's).
- **Color**: ≤3 — primary `1F4E79` (navy, titles), accent `2E75B6` (highlights), + one emphasis/alert. Color DIRECTS attention (highlight the key result), never decorates.
- **Type sizes**: action title 24–28pt bold; body ≥20pt; chart labels 16–18pt; citations 12–14pt muted.
- **Layout**: left-align body; center only titles/axis labels; results slide = figure LEFT, interpretation RIGHT; ≥0.5" margins; leave white space.
- **Avoid**: decorative icons, stock art, themed gradients, full-bleed images on content slides, >~40 words body text, and NEVER an accent line under a title (hallmark of AI slides — use whitespace).

Full palette + FONTS/MARGIN constants are in slide_patterns.md §Global Defaults.

---

## Step 3 — Get figures onto the slides

Read **[figures.md](figures.md)**. Key points:
- The pptx skill embeds images (PNG/JPG) and native charts (BAR/LINE/SCATTER/…), but has **NO native LaTeX**. Equations and math-labeled plots must be **pre-rendered to images**.
- For true-LaTeX plot text (axis labels, annotations), render matplotlib with `rcParams["text.usetex"]=True` → save PNG → embed.
- **Before building any results slide, scan `figures/ results/ plots/ outputs/` for the real figure and embed it** — don't invent a chart when the actual result exists. Rebuild paper figures at presentation resolution (≥16pt labels), don't screenshot the PDF.

---

## Step 4 — Build and QA

Build via the pptx skill (or Slidev/Marp if that track was chosen). Then run the pptx skill's QA loop IN FULL:
- Content QA: `python -m markitdown output.pptx` — check content, order, no leftover placeholder text.
- Visual QA: render slides to images (pptx skill's soffice→pdftoppm), inspect with a SUBAGENT (fresh eyes catch overflow/overlap/low-contrast you won't). This step is what prevents the #1 AI-deck failure: "looks done but is broken when you open it."
- Fix → re-verify affected slides → repeat until a clean pass.

**Additionally run the ML research checklist** (content_guidelines.md §9). Do not declare success until at least one fix-and-verify cycle is done.

---

## Key principles (summary)

- **Action titles, not topic labels.** Every title is a sentence stating the takeaway. Titles alone = the whole argument (ghost-deck test).
- **One argument, made well.** Don't cram the whole paper. Pick the claim you can prove in the time. Rest → appendix.
- **One exhibit per results slide**, key finding annotated directly on the chart. Don't make the audience hunt.
- **Slides carry evidence; you carry the argument.** Body text orients, it doesn't transfer information.
- **Show the real numbers.** Use actual results/figures from the repo, cite baselines, report CIs/seeds/variance where relevant. ML audiences distrust vibes.
- **End on conclusions**, which stays up during Q&A. Never end on "Thank You" or blank.

## Dependencies (same as pptx skill)

- `pip install "markitdown[pptx]"` — text extraction / content QA
- `npm install -g pptxgenjs` — create from scratch
- LibreOffice (`soffice`) + Poppler (`pdftoppm`) — render slides to images for visual QA
- matplotlib + a working LaTeX install (`text.usetex`) — true-LaTeX figures (see figures.md)
- Optional HTML track: `npm i -g @marp-team/marp-cli` (Marp) or `npm i -g @slidev/cli` (Slidev)
