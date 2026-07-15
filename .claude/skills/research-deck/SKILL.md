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

## Step 0 — Defaults + one question

**(a) Aesthetic mode — DEFAULT TO WHITE MINIMAL. Do NOT ask.**
The user's standing preference is a **white minimal academic background — never dark/black**
(eye-friendly, professional). Apply the communication-first design rules in Step 2 by default;
these OVERRIDE the pptx skill's design-forward defaults.
- Only use **visual/dark** mode if the user EXPLICITLY asks for it this once. Even then, keep the
  white background unless they specifically want dark.
- **Dark source figures** (wandb-style charts on a black background) must be **RE-RENDERED on white**
  before embedding — a dark chart on a white slide reads as an ugly floating rectangle. See figures.md.

**(b) Output track — ask this:**
> "Editable **.pptx** (co-authors can edit, matches a lab/venue template) or **HTML/PDF** you present yourself?"

- **.pptx** → drive the `pptx` skill (create-from-scratch via pptxgenjs, or edit-from-template).
- **HTML/PDF, math/code-heavy talk** → you MAY instead scaffold a **Slidev** or **Marp** deck (native LaTeX via KaTeX/MathJax, code line-stepping). Still apply this skill's narrative structure. Only do this if the user is fine without an editable .pptx.

**(c) Data/results — ASK where the results are.** Do NOT invent numbers.
> "Where are the results? Point me at figures / a CSV / a table / numbers in the prompt / wandb (which runs), or paste them."

Accept ANY source: existing PNGs, CSV, a results table, numbers in the prompt, or wandb.
For wandb, use the **`wandb-primary` skill** to fetch run histories — ask the user for the
entity/project and which runs/metrics (or read them from a local wandb config). **If it needs an
API key and none is set, ASK the user.**

**FIGURES ARE RECREATED FOR THE STORY — this is a rule, not an option.**
Whatever the user gives (even a finished figure) is treated as a **DATA SOURCE**, not a final asset.
The narrative dictates the exhibit: the right chart type, the focal number annotated, white/minimal,
≥16pt labels. So you almost always **re-plot from the underlying numbers** rather than embed as-is —
because (i) the story may need a different chart than they have, (ii) dark figures must go white,
(iii) paper/screenshot figures have print-size fonts. Only embed a given figure unchanged if it is
ALREADY white, already the right exhibit for the point, and readable. When given only a dark PNG with
no recoverable numbers, pull the numbers from wandb (or ask), then rebuild. See figures.md.

Also collect: talk length (sets slide budget) and venue/template if any.

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

## Step 2 — Design rules (WHITE MINIMAL — the default)

(These apply unless the user explicitly asked for visual/dark. Keep narrative rules either way.)

- **Background** WHITE for ALL slides, including title + conclusions. Do NOT use dark navy/black
  backgrounds anywhere (standing user preference). For title/conclusions, differentiate with a
  colored accent bar or a light-tinted band — never a dark fill.
- **Font**: one sans-serif throughout (Arial/Calibri/Helvetica, or the venue template's).
- **Color**: ≤3 — primary `1F4E79` (navy, titles), accent `2E75B6` (highlights), + one emphasis/alert. Color DIRECTS attention (highlight the key result), never decorates.
- **Type sizes (HARD)**: action title 24–28pt bold; **body 20pt, absolute floor 18pt — never shrink body to fit, cut text instead**; chart labels 16–18pt; citations 12–14pt muted. Body <18pt = failed slide.
- **Layout**: left-align body; center only titles/axis labels; results slide = figure LEFT, interpretation RIGHT; ≥0.5" margins; leave white space.
- **Avoid**: decorative icons, stock art, themed gradients, full-bleed images on content slides, >~40 words body text, and NEVER an accent line under a title (hallmark of AI slides — use whitespace).

Full palette + FONTS/MARGIN constants are in slide_patterns.md §Global Defaults.

---

## Step 3 — Build the figure the STORY needs (recreate, don't just embed)

Read **[figures.md](figures.md)**. The exhibit is chosen by the slide's action title, then plotted
from the underlying numbers. Key points:
- **Recreate for the story.** For each results slide, decide the exhibit the point needs (dumbbell for
  a before/after gap, line chart for convergence, annotated bar for a single comparison, table for an
  ablation grid), then plot it white/minimal with the focal number annotated. Re-plot from numbers even
  if the user handed you a finished figure — unless it's already white, already the right exhibit, and readable.
- **Get the numbers** from whatever the user pointed at (Step 0c): CSV / table / prompt / existing figure /
  **wandb** (via the `wandb-primary` skill — ask for an API key if none is set). NEVER invent numbers; if
  you have only a dark PNG and can't recover the data, pull it from wandb or ask.
- The pptx skill embeds images (PNG/JPG) and native charts (BAR/LINE/SCATTER/…), but has **NO native LaTeX**.
  Equations and math-labeled plots must be **pre-rendered to images**.
- For true-LaTeX plot text, render matplotlib with `rcParams["text.usetex"]=True` → save PNG → embed.
- Rebuild paper figures at presentation resolution (≥16pt labels), don't screenshot the PDF.

---

## Step 4 — Speaker notes (ALWAYS — a full spoken script, not bullets)

**Every slide gets speaker notes, and they are a full word-for-word speaking script** — what the
presenter actually SAYS, start to finish. This is a default deliverable, not optional.

### The one goal: it must sound like a HUMAN TALKING, not text read aloud

The test for every note: if you close your eyes and hear it, does it sound like a person explaining
their work to a colleague? Or does it sound like someone reading an essay? It must be the first.
The difference is not "casual words". It is the RHYTHM and MOVES of real speech:

- **Talk TO the audience, not at the slide.** "You can see the blue line just stops here." "Notice how
  the two curves split early." Point at things like a person standing at a screen.
- **Think out loud.** Real speakers show the reasoning as it unfolds: "So the natural question is…",
  "and at first I thought it was a bug, but…", "the reason this matters is…". Let them follow your logic.
- **React to your own results like a person.** "This one surprised me." "Honestly, this is my favorite
  plot." "This part is a little embarrassing but it is the interesting bit." Emotion + honesty = human.
- **Vary the rhythm.** Mix short punchy lines with one longer one. A three-word sentence hits: "It broke.
  Same method. Opposite result." Do not make every sentence the same medium length — that is the tell of
  generated text.
- **Keep each sentence SHORT — at most TWO joined ideas.** A listener can hold "A, and B." They lose
  "A, and B, but C, which D." If you're joining three or more clauses with commas / and / but / so /
  which, split it into separate sentences. When in doubt, use a period. This matters more in speech than
  in writing, because the audience can't re-read. One breath ≈ one sentence.
- **Use real spoken glue,** not written connectors. Yes: "so", "okay", "now", "here is the thing",
  "the point is", "look", "right", "anyway", "which is nice because…". No: "furthermore", "moreover",
  "additionally", "thus", "hence", "as such", "in conclusion".
- **Contractions and light filler are GOOD here** (this is speech): "we're", "it's", "that's",
  "kind of", "basically", "it turns out". A little imperfection reads as human. (This softens the earlier
  "keep contractions light" rule — for the SPOKEN script, contractions help.)
- **Callbacks.** Refer to earlier slides the way a speaker does: "remember that 0.84 baseline?",
  "this is the strip step I mentioned".
- **NEVER restate the slide text.** The slide shows the exhibit; you say the story around it — the
  intuition, why you did it, the honest caveat, and the hand-off to the next slide.

### Hard constraints (still apply)

- **SIMPLE ENGLISH for a non-native speaker.** Technical jargon is fine and expected (GRPO, advantage,
  gradient, off-policy, rollout, baseline, ablation, importance-sampling…). Non-technical words stay
  simple and everyday. No rare/fancy vocabulary, no idioms a non-native speaker wouldn't use.
  Avoid: reframes, oversell, baked into, slamming, buys it, poke at, gigantic. Plain forms instead.
- **NO em-dashes.** A listener can't hear a dash. Break it into speech: a period, a comma, or a word.
  - category then example → **"like"**, not a comma pair: "a weak model like Qwen2.5-7B", NOT "a weak
    model, Qwen2.5-7B," (that sounds like a list). Same for "a method like DAPO".
  - a written aside ("— just as important —") → its own sentence: "And just as important, …".
  (Slide TEXT may keep em-dashes; this rule is only for the spoken notes.)
- **Honest in voice** — state limits plainly: "I don't want to over-claim here."
- **~50–120 words per slide** (title/section shorter). Read it out loud in your head before moving on.

### Before / after (same content)

- ❌ text-read-aloud: "The results demonstrate that nudging achieves approximately 2x faster convergence,
  reaching 0.6 success at step 160 versus 225 for the baseline; however, final performance is comparable."
- ✅ human talking: "Okay, results. Look at where the lines cross 0.6. Nudge gets there around 160, the
  baseline needs like 225. So early on we're almost twice as fast. Now, I don't want to oversell it,
  because by the end they all kind of meet up. So the honest story here is speed, not a higher final score."

How to attach:
- **pptx** → `slide.addNotes("…")` on every slide (verify: unzip → 12 `ppt/notesSlides/notesSlideN.xml`).
- **Slidev** → an HTML comment `<!-- … -->` as the LAST block of each slide (shows in presenter mode).

---

## Step 5 — Build and QA

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
- **Every slide ships a full spoken script** in the speaker notes — casual FAANG/top-lab voice, not slide-text read aloud (Step 4).

## Related: writing-craft (prose), not for slide bullets

The `writing-craft` skill governs PROSE (sentences/paragraphs). Do NOT apply its paragraph rules
(given→new flow, one-idea-per-sentence, full-sentence polish) to slide bullets — slides use telegraphic
fragments on purpose. This skill already carries the slide-appropriate versions (action titles = so-what,
ghost-deck test, ≤40 words). Use writing-craft only on the PROSE artifacts behind a talk (the paper, a blog
post) — and on the two sentence-like slide elements this skill owns: action titles and speaker-note scripts.

## Dependencies (same as pptx skill)

- `pip install "markitdown[pptx]"` — text extraction / content QA
- `npm install -g pptxgenjs` — create from scratch
- LibreOffice (`soffice`) + Poppler (`pdftoppm`) — render slides to images for visual QA
- matplotlib + a working LaTeX install (`text.usetex`) — true-LaTeX figures (see figures.md)
- Optional HTML track: `npm i -g @marp-team/marp-cli` (Marp) or `npm i -g @slidev/cli` (Slidev)
