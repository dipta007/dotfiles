# Figures — getting ML plots and math onto slides

The `pptx` skill embeds **images** (PNG/JPG via file path/URL/base64) and **native charts**
(BAR, LINE, PIE, DOUGHNUT, SCATTER, BUBBLE, RADAR). It has **NO native LaTeX / equation rendering.**
So: native charts for simple bars/lines built from numbers; **pre-rendered PNGs** for anything with
math, or when the real experimental figure already exists.

**Core principle — RECREATE FOR THE STORY.** Whatever the user gives (a finished figure, a CSV, a table,
numbers in the prompt, a wandb run) is a **DATA SOURCE**, not a final asset. The slide's action title
decides the exhibit; you plot it from the numbers, white/minimal, focal point annotated. Re-plot even a
polished figure unless it's already white, already the right exhibit for THIS point, and readable.

Decision rule:
- Pick the exhibit from the point: gap → dumbbell; convergence/trend → line; single comparison → annotated bar; ablation grid → table; math → pre-rendered image.
- Build it from the numbers with matplotlib (see §2), white bg, ≥16pt labels.
- Only embed a user-supplied figure UNCHANGED if it's already white + already the right exhibit + readable.
- Equations / Greek / sub-superscript labels → `text.usetex` → PNG (§3–4).

---

## 0. Get the numbers first (data-source ladder)

Ask where the results are (SKILL Step 0c), then get the numbers — never invent them:

1. **Numbers in the prompt / a table** → use directly.
2. **CSV / json / parquet** in the repo → read it (`pandas`).
3. **Existing figure (PNG/SVG/PDF)** → if it has a data source (HTML with inline data, a plotting
   script, a CSV), use that. A bare PNG is pixels — recover the numbers from its source, or from wandb.
4. **wandb** → use the **`wandb-primary` skill** to pull run history. This repo: entity `collab-srd`,
   project `amazon26`; match runs by name (= `EXPERIMENT_NAME`, e.g. `Q3_4bI_terminal_..._v141`);
   common metric keys `val-aux/appworld/success/mean@4` (mean success@4) and `.../best@4/mean`.
   **If it needs an API key and none is set, ASK the user for it.** (Template: a small pull script that
   caches `run.history(keys=[...])` to JSON, then §2 plots it.)

Never fabricate a curve or a number. If none of the above yields data, ask the user.

## 1. Recreate the figure white, at presentation quality

A given figure is a starting point, not the output. Rebuild it (see §2) so it: (i) is white-background,
(ii) is the exhibit the point needs, (iii) has ≥16pt labels, (iv) annotates the focal number directly.

Only if a figure is ALREADY white + right-exhibit + readable, embed it unchanged (`contain` keeps ratio):

```javascript
slide.addImage({ path: "figs_light/main_result.png", x: 0.5, y: 1.15, w: 5.4, h: 3.8, sizing: { type: "contain", w: 5.4, h: 3.8 } });
```

Vector `.pdf` source → rasterize at presentation DPI: `pdftoppm -png -r 200 curve.pdf curve`.
**Never screenshot a paper figure** — print-size fonts vanish on a projector; rebuild from the numbers.

---

## 2. Presentation-quality matplotlib defaults

Re-render any plot destined for a slide with readable fonts and a transparent/whitish background:

```python
import matplotlib as mpl
import matplotlib.pyplot as plt

mpl.rcParams.update({
    "font.size": 18,          # base; axis labels land ~18-20pt on-slide
    "axes.titlesize": 20,
    "axes.labelsize": 18,
    "xtick.labelsize": 15,
    "ytick.labelsize": 15,
    "legend.fontsize": 15,
    "lines.linewidth": 2.5,
    "figure.dpi": 200,
    "savefig.bbox": "tight",
    "savefig.transparent": True,   # blends onto white OR dark slides
})

fig, ax = plt.subplots(figsize=(6.4, 4.2))   # ~ fills the left half of a 16:9 slide
# ... plot ...
ax.set_xlabel("Training steps")
ax.set_ylabel("Val success rate")
fig.savefig("figures/main_result.png")       # PNG for the slide
```

Annotate the focal point IN the figure (so the slide needs no extra callout):

```python
ax.annotate("+4.2 over baseline", xy=(x_star, y_star), xytext=(x_star, y_star+0.08),
            arrowprops=dict(arrowstyle="->", lw=2), fontsize=16, fontweight="bold")
```

Color: don't rely on color alone (colorblind + projector shift). Add markers/linestyles:
```python
ax.plot(x, ours, "-o", label="Ours")
ax.plot(x, base, "--s", label="Baseline")
```

---

## 3. TRUE LaTeX in figures (`text.usetex`)

For genuine LaTeX text (matching your paper's fonts / complex math in labels), shell out to a real
LaTeX install. Needs a working TeX + `dvipng` (e.g. TeX Live / MacTeX). Distinct from matplotlib's
built-in mathtext (which handles simple `$...$` WITHOUT a LaTeX install and is enough for most labels).

```python
import matplotlib as mpl
mpl.rcParams["text.usetex"] = True                     # real LaTeX for ALL text
mpl.rcParams["font.family"] = "serif"
mpl.rcParams["text.latex.preamble"] = r"\usepackage{amsmath}\usepackage{amssymb}"

ax.set_xlabel(r"KL divergence $D_{\mathrm{KL}}(\pi_\theta \,\|\, \pi_{\mathrm{ref}})$")
ax.set_title(r"Reward vs.\ $\beta$ (Dr.\ GRPO, $\gamma{=}1$)")
```

If `text.usetex=True` errors (no LaTeX installed), fall back to mathtext: set it back to `False` and
keep the `$...$` — simple equations still render. Only real LaTeX needs the TeX install.

---

## 4. Standalone equation → image (for equation slides)

The pptx skill can't typeset an equation on a slide. Render it to a tight PNG and embed:

```python
import matplotlib.pyplot as plt
fig = plt.figure(figsize=(6, 1.4)); fig.patch.set_alpha(0)
fig.text(0.5, 0.5,
    r"$\mathcal{L}_{\mathrm{GRPO}} = -\mathbb{E}_{o\sim\pi_\theta}\!\left[\min\big(r_t A_t,\ \mathrm{clip}(r_t,1{-}\epsilon,1{+}\epsilon)A_t\big)\right]$",
    ha="center", va="center", fontsize=22)
fig.savefig("figures/eq_grpo.png", dpi=220, bbox_inches="tight", transparent=True)
```

(`text.usetex=True` here too if you want paper-identical typesetting.) Then `slide.addImage(...)` it,
centered, with the intuition as a one-line caption below. Keep one equation per slide; explain each symbol.

---

## 5. Tables (ablation grids / leaderboards)

Small numeric tables are fine as native pptx tables — bold the winning row/number, right-align numbers:

```javascript
slide.addTable(rows, { x: 0.5, y: 1.2, w: 9, fontSize: 16, border: { pt: 0.5, color: "CCCCCC" },
                       align: "center", valign: "middle" });
// build `rows` with per-cell { text, options:{ bold, color, fill } }; bold the SOTA row.
```

Big tables belong in the appendix — on the main slide show only the rows that make the point.

---

## 6. Diagrams (architecture / method-at-a-glance)

- **minimal mode**: build from pptx shapes + arrows + text (boxes for modules, arrows for data flow). Keep it schematic.
- **visual mode**: an existing architecture PNG is fine; or generate one. Rebuild at ≥16pt labels either way.
- If you have a TikZ/Graphviz/mermaid source, render it to PNG/PDF and embed rather than recreating by hand.

Keep the diagram to the ONE abstraction the audience needs to follow the results. Detail → appendix.
