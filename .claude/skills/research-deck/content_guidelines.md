# Content Guidelines — ML/AI Research Decks

Adapted from Gabberflast/academic-pptx-skill (MIT), grounded in Minto's Pyramid Principle
and Naegle (2021), "Ten Simple Rules for Effective Presentation Slides" (PLOS Comp Biol).
ML-tuned throughout.

## 1. Argument structure

### Lead with the problem, then the gap
State the task/problem and WHY it matters in the first 1–2 content slides, then the specific
gap in existing methods. The audience needs the "why" before any method makes sense. Don't bury it.

### Default spine: Problem → Gap → Method → Results → Takeaway
This is Situation/Complication/Resolution for ML:
- **Problem (Situation):** the task, the setting, what's currently possible.
- **Gap (Complication):** where existing methods / baselines fall short — the thing you fix.
- **Method (Resolution part 1):** your approach; only the parts needed to understand the results.
- **Results (Resolution part 2):** the evidence it works — main result first, then ablations.
- **Takeaway:** what changed, what it means, what's next.

Alternative — **Answer-first**: lead with the headline result ("We cut X error 30% with a method that
needs no extra labels"), then justify. Use for short talks, reading groups, or senior audiences.

### One argument per talk
Resist presenting the whole paper. Pick the ONE claim you can make convincingly in the time.
Extra experiments, derivations, and hyperparameters go in the appendix.

### Each slide has one job
If a slide does two things, split it. Read titles in order (flow test): each should make the next
feel like a natural consequence. A slide that could sit anywhere without loss is misplaced or dispensable.

---

## 2. Action titles (the most important rule)

Every content-slide title is a complete sentence stating the takeaway — the "so what" — not a topic label.

| Instead of (topic label) | Use (action title) |
|--------------------------|--------------------|
| Results | Our method beats the strongest baseline by 4.2 BLEU with no extra data |
| Related Work | Prior RL-from-feedback methods need a reward model we can't train here |
| Method | A single value head lets us drop the critic and halve training cost |
| Ablations | Removing the auxiliary loss drops accuracy 6 pts — it's load-bearing |
| Dataset | We evaluate on 3 benchmarks spanning 12 languages and 40k examples |
| Motivation | LLM agents fail on long-horizon tasks because credit assignment is sparse |

**Ghost-deck test:** read only the action titles top to bottom. They must tell the complete story.
If they don't, the deck's logic is broken — fix titles / restructure before building.

**Length:** 1–2 lines. If longer, the point isn't sharp yet. **Font:** 24–28pt bold, readable from the back.

---

## 3. Exhibit discipline

### One exhibit per slide
One chart, table, diagram, equation block, or curve per slide. Two charts only if they're really one
comparison. Two separate points → two slides.

### Every exhibit earns its place
Cover the exhibit, read the title — still makes sense? Then the exhibit may be unnecessary.
Cover the title, look at the exhibit — is the takeaway obvious? If not, add a stronger annotation or title.

### Annotate the key finding ON the chart
Don't make the audience search. Mark the focal bar/line/cell/row with an arrow, a highlighted region,
a text callout ("↑ +4.2 BLEU"), or a distinct color for the focal series. Critical for large rooms.

### Show ML evidence honestly
- Report **variance**: error bars, CIs, or ±std over seeds. A single-seed bar chart invites skepticism.
- Name the **baselines** and make the comparison fair (same data/compute) — say so.
- For training curves: label axes (steps/epochs vs. metric), mark the compared checkpoints, note the metric.
- Prefer **graphs over tables** for trends/comparisons; reserve tables for exact numbers that matter
  (e.g., a benchmark leaderboard, an ablation grid). Bold the winning row/number.

### Rebuild figures at presentation resolution
Don't screenshot the paper PDF — print fonts are too small on screen. Rebuild from the source
(matplotlib/seaborn) with ≥16pt axis labels. See figures.md.

### Don't include exhibits you won't discuss
If it's on a slide, discuss it. If you won't have time, move it to the appendix.

---

## 4. Text discipline

- **≤ ~40 words body text per slide.** More → split the slide or move to appendix.
- **Bullets are orientation cues, one idea each.** 3–5 per slide; >5 is a warning sign.
- **Telegraphic language is fine.** "Method reduces val loss 12%, no extra labels (Table 2)" beats a full sentence.
- **Body font ≥ 20pt.** A floor, not a target. If it must be smaller to fit, cut content.
- **Bold/italics sparingly:** bold for a key term on first use, inline labels ("Note:", "Limitation:"),
  and the focal number. Italics for math notation and dataset/model names. Not decoration.

---

## 5. Citations and attribution

- **Cite on the slide**: every borrowed figure, dataset, or claim gets an in-slide citation (bottom,
  12–14pt muted), `(Author, Year)` or `[N]` — be consistent.
- **Figures from papers**: attribution caption under the figure ("Source: Vaswani et al., 2017, Fig. 1")
  + full entry on the References slide.
- **References slide** before the appendix, complete and consistently formatted (a BibTeX-style list is fine).
- Introduce sources verbally, don't silently flash a parenthetical.

---

## 6. Deck architecture (ML talk)

In order:

- **Title** — title framed as a claim or question (not just a topic); authors + affiliations; venue; date.
  Add arXiv id / code URL / QR if public.
- **Motivation / Problem (1–2)** — why this task matters; the real-world or scientific stakes. (Situation + start of Complication.)
- **Gap / Related work (1)** — what existing methods do and precisely where they fall short. This is what your method fixes.
- **Approach at a glance (1)** — one diagram: the method in a single picture. Orient before details.
- **Method (1–2)** — only what's needed to interpret the results. Formal detail / proofs / full hparams → appendix.
- **Setup (1, optional)** — datasets, baselines, metrics, compute. Keep tight; details → appendix.
- **Results (1 per finding)** — main result first, then key ablations. One exhibit each, action title states the finding, focal number annotated. Show variance.
- **Analysis / why it works (0–2, optional)** — qualitative examples, failure cases, what the ablation reveals.
- **Limitations (part of discussion)** — name the main one directly; pre-empt the obvious reviewer objection.
- **Conclusions (1)** — 2–4 takeaways. Stays on screen during Q&A. Not followed by "Thank You" or blank.
- **Contact / links** — email, code/arXiv URL, QR — on the conclusions slide or a final one.
- **References**.
- **Appendix (labeled)** — pre-built Q&A slides for likely questions ("why not method X?", "how does it
  scale?", "what about compute?", "significance?"), extra ablations, hyperparameters, proofs, more examples.

---

## 7. Timing / slide budget

Max ~1 slide/minute. Typical:
- 5-min spotlight: 5–7 content slides — main result MUST appear by slide 3–4.
- 12-min conference talk: 10–12 content slides.
- 20-min: 15–18. 45–60-min seminar: 30–40 (more discussion per slide).

Rehearse aloud, target finishing 1–2 min UNDER. Mark slides to skip if short on time; protect
problem, main result, conclusions. Pre-build appendix slides for the 3–5 likeliest questions.

---

## 8. Accessibility / international audiences

- ≥20pt body, ≥24pt titles; high contrast; never rely on color alone (add labels/patterns/markers —
  matters for colorblind viewers reading a scatter or multi-line curve).
- Define every acronym on first use, even "obvious" ones (SFT, RM, GRPO, RLHF, KV-cache…).
- Avoid idioms; plain direct sentences; alt text on figures if the deck circulates as PDF.

---

## 9. ML research QA checklist (run in addition to the pptx skill's visual QA)

```
□ Every content slide has an action title (complete sentence, states the takeaway)
□ Ghost-deck test passes (action titles alone tell the full Problem→Gap→Method→Results→Takeaway arc)
□ Main result appears early enough for the talk length (spotlight: by slide 3–4)
□ One exhibit per results slide; focal number/bar/row annotated on the exhibit
□ Results show variance (error bars / CI / ±std over seeds) OR explicitly note single-run
□ Baselines named; comparison is fair (same data/compute) and said to be
□ Real figures pulled from figures/ results/ plots/ — not invented; rebuilt at ≥16pt labels
□ Equations/math-labeled plots pre-rendered to images (pptx has no native LaTeX)
□ Every borrowed figure/dataset/claim has an in-slide citation; References slide present
□ Acronyms defined on first use; color not the only signal
□ Conclusions is the last main slide; stays up during Q&A; contact/code/arXiv present
□ Body text ≥20pt; ≤~40 words/slide; no accent line under any title
□ Appendix slides labeled, pre-built for the 3–5 likeliest questions
□ Deck runs 1–2 min under the limit when practiced aloud
```

---

## 10. Common mistakes → fixes

| Mistake | Fix |
|---------|-----|
| Topic-label titles ("Results") | Action title stating the finding |
| Presenting the whole paper | One argument; rest → appendix |
| Reading slides aloud | Slides carry evidence; you carry the argument |
| Chart with no "so what" | Annotate the focal number directly on it |
| Single-seed bar chart, no variance | Add error bars/CI or state it's one run |
| Screenshotting paper figures | Rebuild from source at presentation resolution |
| Equation as raw text / broken glyphs | Pre-render LaTeX to an image (figures.md) |
| Method slide dumps every hyperparameter | Keep what's needed to read results; rest → appendix |
| Text-heavy, marketing-speak slides | ≤40 words; concrete numbers; telegraphic phrasing |
| Ending on "Thank You" | End on conclusions; it stays up during Q&A |
| Undefined acronyms | Define on first use |
| No references slide | Always include one |
