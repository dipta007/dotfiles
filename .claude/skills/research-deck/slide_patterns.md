# Slide Patterns — ML/AI decks (PptxGenJS)

Concrete PptxGenJS patterns per ML slide type. Use with the pptx skill's `pptxgenjs.md` for the full API.
All coords assume `LAYOUT_16x9` (10" × 5.625"). These are MINIMAL-mode patterns; in visual mode keep the
structure but you may add diagrams/accents per the pptx skill's design guidance.

---

## Global defaults

```javascript
const COLORS = {
  bg:        "FFFFFF",   // white content background
  primary:   "1F4E79",   // dark navy — titles, title/conclusion bg
  accent:    "2E75B6",   // mid-blue — headers, focal series
  body:      "2D2D2D",   // near-black — body text
  muted:     "777777",   // gray — citations, captions
  rule:      "CCCCCC",   // light gray — dividers
  highlight: "FFF2CC",   // pale yellow — callouts (sparingly)
  good:      "2E7D32",   // green — wins / our method
  bad:       "C62828",   // red — failures / alerts
};
const FONTS = { face: "Arial", title: 26, sectionHeader: 22, body: 20, label: 16, cite: 13 };
const MARGIN = 0.5;
```

Two reusable helpers (define once, call per slide):

```javascript
function actionTitle(slide, text, y = 0.2, h = 0.85) {
  slide.addText(text, { x: MARGIN, y, w: 9.0, h, fontSize: FONTS.title, fontFace: FONTS.face,
                        color: COLORS.primary, bold: true, valign: "top" });
  slide.addShape(pres.shapes.RECTANGLE, { x: MARGIN, y: y + h + 0.05, w: 9.0, h: 0.025, fill: { color: COLORS.rule } });
}
function cite(slide, text) {
  slide.addText(text, { x: MARGIN, y: 5.12, w: 9.0, h: 0.3, fontSize: FONTS.cite, fontFace: FONTS.face, color: COLORS.muted });
}
```

---

## 1. Title slide (dark)

```javascript
slide.background = { color: COLORS.primary };
slide.addText("Insight-Guided RL: teacher hints rescue the hard groups\nGRPO can't learn from", {
  x: 0.7, y: 1.4, w: 8.6, h: 1.8, fontSize: 32, fontFace: FONTS.face, color: "FFFFFF", bold: true, align: "left", valign: "top" });
slide.addText("NeurIPS 2026  ·  Efficient RL for LLM Agents workshop", {
  x: 0.7, y: 3.2, w: 8.6, h: 0.4, fontSize: 16, fontFace: FONTS.face, color: "A0BBDD" });
slide.addText("Your Name¹  ·  Coauthor²\n¹ Your Lab   ² Affiliation", {
  x: 0.7, y: 3.7, w: 8.6, h: 0.6, fontSize: 15, fontFace: FONTS.face, color: "CADCFC" });
// arXiv / code
slide.addText("arxiv.org/abs/XXXX.XXXXX   ·   github.com/you/repo", {
  x: 0.7, y: 4.7, w: 8.6, h: 0.4, fontSize: 13, fontFace: FONTS.face, color: "7BAFD4" });
```

---

## 2. Motivation / problem

```javascript
actionTitle(slide, "LLM agents fail on hard tasks where every GRPO rollout gets 0 reward — no gradient, no learning");
slide.addText([
  { text: "GRPO learns from within-group reward variance. ", options: { bold: true, breakLine: false } },
  { text: "When all K rollouts in a group fail, advantage = 0 → that task teaches nothing.", options: { breakLine: true } },
  { text: "Hard tasks stay hard: ", options: { bold: true, breakLine: false } },
  { text: "the exact examples we most want to learn from produce no signal.", options: { breakLine: true } },
  { text: "Curriculum / reward-shaping help partially, ", options: { bold: true, breakLine: false } },
  { text: "but don't create signal on all-fail groups.", options: { breakLine: true } },
], { x: MARGIN, y: 1.1, w: 9.0, h: 3.2, fontSize: FONTS.body, fontFace: FONTS.face, color: COLORS.body, bullet: true, paraSpaceAfter: 12 });
cite(slide, "Shao et al. (2024), DeepSeekMath (GRPO); Guo et al. (2025)");
```

---

## 3. Gap / related work

```javascript
actionTitle(slide, "Existing fixes give partial signal — none inject knowledge into an all-fail group online");
// Two-column: what they do (left) / what's missing (right)
slide.addText("Prior approaches", { x: MARGIN, y: 1.25, w: 4.3, h: 0.35, fontSize: FONTS.sectionHeader, fontFace: FONTS.face, color: COLORS.accent, bold: true });
slide.addText([
  { text: "Reward shaping — dense proxy reward", options: { breakLine: true } },
  { text: "Curriculum — reorder by difficulty", options: { breakLine: true } },
  { text: "SFT warmstart — imitate before RL", options: { breakLine: true } },
], { x: MARGIN, y: 1.65, w: 4.3, h: 2.6, fontSize: FONTS.body, fontFace: FONTS.face, color: COLORS.body, bullet: true, paraSpaceAfter: 10 });
slide.addText("What's still missing", { x: 5.3, y: 1.25, w: 4.2, h: 0.35, fontSize: FONTS.sectionHeader, fontFace: FONTS.face, color: COLORS.accent, bold: true });
slide.addText([
  { text: "Shaping can't create signal if NO rollout succeeds", options: { breakLine: true } },
  { text: "Curriculum defers hard tasks, doesn't solve them", options: { breakLine: true } },
  { text: "SFT is offline; can't adapt to the live policy's failures", options: { breakLine: true } },
], { x: 5.3, y: 1.65, w: 4.2, h: 2.6, fontSize: FONTS.body, fontFace: FONTS.face, color: COLORS.body, bullet: true, paraSpaceAfter: 10 });
```

---

## 4. Approach at a glance (one-diagram slide)

Build the method as a schematic (boxes + arrows). One picture, no detail.

```javascript
actionTitle(slide, "On an all-fail group, a teacher LLM writes a hint; we append it, regenerate, and train the prefix");
const box = (x, y, w, label, fill) => {
  slide.addShape(pres.shapes.ROUNDED_RECTANGLE, { x, y, w, h: 0.9, fill: { color: fill }, line: { color: COLORS.accent, pt: 1 }, rectRadius: 0.06 });
  slide.addText(label, { x, y, w, h: 0.9, fontSize: 14, fontFace: FONTS.face, color: COLORS.body, align: "center", valign: "middle" });
};
box(0.5, 2.2, 2.0, "GRPO group\nall K fail", "F2F2F2");
box(2.9, 2.2, 2.0, "Teacher LLM\ngenerates hint", COLORS.highlight);
box(5.3, 2.2, 2.0, "Append hint →\nregenerate", "EBF3FA");
box(7.7, 2.2, 1.8, "Train prefix\nstrip hint", "E8F5E9");
[2.5, 4.9, 7.3].forEach(x => slide.addShape(pres.shapes.RIGHT_ARROW, { x, y: 2.5, w: 0.4, h: 0.3, fill: { color: COLORS.accent } }));
cite(slide, "See method slide for the strip step (hint never enters the trained gradient)");
```

---

## 5. Method detail (1–2 slides, only what's needed)

```javascript
actionTitle(slide, "The hint conditions generation but is stripped before the loss — so we train p(solution | task), not p(·| task+hint)");
slide.addText([
  { text: "Trigger: ", options: { bold: true, breakLine: false } },
  { text: "group where max reward = 0 (all rollouts fail).", options: { breakLine: true } },
  { text: "Hint: ", options: { bold: true, breakLine: false } },
  { text: "teacher sees the task + a failed trace, emits a short natural-language hint.", options: { breakLine: true } },
  { text: "Regenerate: ", options: { bold: true, breakLine: false } },
  { text: "prompt = task + hint; sample K new rollouts → now some succeed → non-zero advantage.", options: { breakLine: true } },
  { text: "Strip: ", options: { bold: true, breakLine: false } },
  { text: "physically remove the hint span from the sequence used for the policy-gradient loss.", options: { breakLine: true } },
], { x: MARGIN, y: 1.1, w: 9.0, h: 3.4, fontSize: FONTS.body - 1, fontFace: FONTS.face, color: COLORS.body, bullet: true, paraSpaceAfter: 10 });
cite(slide, "Full strip + log-prob alignment: Appendix B");
```

---

## 6. Results slide (figure left, interpretation right, focal number annotated)

Prefer embedding the REAL figure (see figures.md). Native chart shown as fallback.

```javascript
actionTitle(slide, "Global nudging lifts hard-group solve rate 0.31 → 0.58 with no change to the base GRPO objective", 0.2, 0.8);
// REAL figure (preferred):
slide.addImage({ path: "figures/hard_group_solve.png", x: MARGIN, y: 1.15, w: 5.4, h: 3.8, sizing: { type: "contain", w: 5.4, h: 3.8 } });
// (fallback native chart if no figure exists)
// slide.addChart(pres.charts.BAR, [{ name: "solve rate", labels: ["GRPO","+Nudge"], values: [0.31, 0.58] }],
//   { x: MARGIN, y: 1.15, w: 5.4, h: 3.8, barDir: "col", chartColors: [COLORS.muted, COLORS.good], showValue: true, showLegend: false });

slide.addText("What to take away", { x: 6.2, y: 1.15, w: 3.3, h: 0.35, fontSize: FONTS.sectionHeader, fontFace: FONTS.face, color: COLORS.accent, bold: true });
slide.addText([
  { text: "+27 pts on all-fail groups (the ones GRPO can't touch)", options: { breakLine: true } },
  { text: "Overall val success +4.1 pts; no regression on easy tasks", options: { breakLine: true } },
  { text: "Mean over 3 seeds; shaded = ±1 std", options: { breakLine: true } },
], { x: 6.2, y: 1.55, w: 3.3, h: 2.6, fontSize: FONTS.body - 2, fontFace: FONTS.face, color: COLORS.body, bullet: true, paraSpaceAfter: 12 });
cite(slide, "AppWorld test-normal + test-challenge; Qwen3-4B-Instruct");
```

If the focal number isn't already marked inside the PNG, overlay a callout:
```javascript
slide.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 3.4, y: 1.35, w: 1.7, h: 0.5, fill: { color: COLORS.highlight }, line: { color: "E6C800", pt: 1 }, rectRadius: 0.06 });
slide.addText("+27 pts", { x: 3.4, y: 1.35, w: 1.7, h: 0.5, fontSize: 14, fontFace: FONTS.face, color: "7A5200", bold: true, align: "center", valign: "middle" });
```

---

## 7. Ablation table (bold the load-bearing row)

```javascript
actionTitle(slide, "Every component matters: removing the strip step collapses the gain entirely");
const hdr = t => ({ text: t, options: { bold: true, color: "FFFFFF", fill: { color: COLORS.primary }, align: "center" } });
const cell = (t, opt = {}) => ({ text: t, options: { align: opt.align || "center", bold: !!opt.bold, color: opt.color || COLORS.body, fill: opt.fill ? { color: opt.fill } : undefined } });
const rows = [
  [hdr("Variant"), hdr("Hard-group solve"), hdr("Val success")],
  [cell("Full (ours)", { align: "left", bold: true }), cell("0.58", { bold: true, color: COLORS.good }), cell("0.71", { bold: true, color: COLORS.good })],
  [cell("− strip (train on hint)", { align: "left" }), cell("0.34"), cell("0.55")],
  [cell("− teacher (random hint)", { align: "left" }), cell("0.39"), cell("0.63")],
  [cell("GRPO baseline", { align: "left" }), cell("0.31"), cell("0.67")],
];
slide.addTable(rows, { x: 0.8, y: 1.25, w: 8.4, fontSize: 16, fontFace: FONTS.face, border: { pt: 0.5, color: COLORS.rule }, valign: "middle", rowH: 0.55 });
cite(slide, "Ablations on AppWorld dev; mean of 3 seeds");
```

---

## 8. Equation slide (math is a pre-rendered image — pptx has no LaTeX)

Render the equation to PNG per figures.md §4, then:

```javascript
actionTitle(slide, "The hint enters generation but the loss anchors on the hint-free sequence");
slide.addImage({ path: "figures/eq_strip.png", x: 1.5, y: 1.5, w: 7.0, h: 1.6, sizing: { type: "contain", w: 7.0, h: 1.6 } });
slide.addText([
  { text: "θ-gradient uses log πθ(solution | task), NOT (task+hint). ", options: { bold: true, breakLine: true } },
  { text: "Advantage comes from the regenerated (post-hint) rollouts; the conditioning is removed from the trained sequence.", options: {} },
], { x: MARGIN, y: 3.4, w: 9.0, h: 1.2, fontSize: FONTS.body, fontFace: FONTS.face, color: COLORS.body });
```

---

## 9. Conclusions (dark, mirrors title; stays up during Q&A)

```javascript
slide.background = { color: COLORS.primary };
slide.addText("Conclusions", { x: MARGIN, y: 0.25, w: 9.0, h: 0.45, fontSize: 20, fontFace: FONTS.face, color: "A0BBDD" });
slide.addShape(pres.shapes.RECTANGLE, { x: MARGIN, y: 0.7, w: 9.0, h: 0.04, fill: { color: COLORS.accent } });
slide.addText([
  { text: "1. All-fail groups are the bottleneck: ", options: { bold: true, breakLine: false } },
  { text: "GRPO gets no gradient exactly where we need it most.", options: { breakLine: true } },
  { text: "2. Online teacher hints create signal there: ", options: { bold: true, breakLine: false } },
  { text: "hard-group solve 0.31 → 0.58, no change to the RL objective.", options: { breakLine: true } },
  { text: "3. The strip is load-bearing: ", options: { bold: true, breakLine: false } },
  { text: "we train p(solution | task); the hint never enters the gradient.", options: { breakLine: true } },
], { x: MARGIN, y: 0.85, w: 9.0, h: 3.5, fontSize: FONTS.body + 1, fontFace: FONTS.face, color: "FFFFFF", paraSpaceAfter: 20 });
slide.addText("you@lab.edu   ·   github.com/you/repo   ·   arxiv.org/abs/XXXX.XXXXX", {
  x: MARGIN, y: 4.8, w: 8.0, h: 0.4, fontSize: 14, fontFace: FONTS.face, color: "A0BBDD" });
// optional QR: slide.addImage({ path: "figures/qr.png", x: 8.6, y: 4.5, w: 0.9, h: 0.9 });
```

---

## 10. Section divider (decks > 15 slides)

```javascript
slide.background = { color: "1A3A5C" };
slide.addText("Part 2", { x: MARGIN, y: 1.8, w: 9.0, h: 0.4, fontSize: 16, fontFace: FONTS.face, color: "7BAFD4" });
slide.addText("Results", { x: MARGIN, y: 2.2, w: 9.0, h: 1.0, fontSize: 36, fontFace: FONTS.face, color: "FFFFFF", bold: true });
slide.addShape(pres.shapes.RECTANGLE, { x: MARGIN, y: 3.3, w: 2.5, h: 0.06, fill: { color: COLORS.accent } });
```

---

## 11. References

```javascript
slide.background = { color: COLORS.bg };
slide.addText("References", { x: MARGIN, y: 0.2, w: 9.0, h: 0.5, fontSize: 24, fontFace: FONTS.face, color: COLORS.primary, bold: true });
slide.addShape(pres.shapes.RECTANGLE, { x: MARGIN, y: 0.72, w: 9.0, h: 0.025, fill: { color: COLORS.rule } });
const refs = [
  "Shao, Z. et al. (2024). DeepSeekMath: Pushing the Limits of Mathematical Reasoning. arXiv:2402.03300.",
  "Guo, D. et al. (2025). DeepSeek-R1. arXiv:2501.12948.",
  "Your, N. & Coauthor, M. (2026). Insight-Guided RL. Working paper.",
];
slide.addText(refs.flatMap((r, i) => [{ text: r, options: { breakLine: true } }, ...(i < refs.length - 1 ? [{ text: "", options: { breakLine: true } }] : [])]),
  { x: MARGIN, y: 0.85, w: 9.0, h: 4.5, fontSize: 13, fontFace: FONTS.face, color: COLORS.body, paraSpaceAfter: 8 });
```

---

## 12. Appendix (labeled; pre-built Q&A)

```javascript
slide.addText("Appendix B — Strip correctness", { x: MARGIN, y: 0.15, w: 9.0, h: 0.4, fontSize: 14, fontFace: FONTS.face, color: COLORS.muted, italic: true });
actionTitle(slide, "dirty_rows stays 0 across all steps — no hint token ever reaches the trained gradient", 0.6, 0.75);
// normal content patterns below
```

---

## Pre-delivery checklist

```
□ Title: claim/question framing, authors, venue, arXiv/code
□ Every content slide: action title (sentence, states the takeaway)
□ Ghost-deck test: titles alone tell Problem→Gap→Method→Results→Takeaway
□ Main result appears early enough for the talk length
□ Results slides: one exhibit, focal number annotated, variance shown
□ Real figures embedded from figures/ results/ plots/; ≥16pt labels
□ Equations pre-rendered to images; one equation per slide
□ Ablation tables: winning row bold; big tables in appendix
□ Every borrowed figure/dataset cited on-slide; References slide present
□ Conclusions last main slide; contact/code/arXiv; stays up during Q&A
□ Body ≥20pt; ≤~40 words/slide; no accent line under any title
□ Ran the pptx skill's visual QA (subagent) + fixed at least one cycle
```
