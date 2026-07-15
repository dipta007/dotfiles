# Draft from sources — a grounded first draft

Write a first draft from a blank page using the user's real materials: results/numbers, code, and related
papers. This is the safe version of "write my paper" — grounded in inputs, never free-generated.

## The one hard rule: NEVER invent. Flag gaps instead.

LLM drafting is where fabrication happens — invented numbers, overclaimed results, hallucinated citations
(~half of LLM-generated BibTeX is wrong). So this mode draws EVERY factual claim from a real input. When an
input is missing, you do NOT guess — you write a visible placeholder and move on:

- Missing number/result → `[TODO: number from <where>]`
- Missing citation → `[TODO: cite — <what claim needs support>]`
- Claim you can't ground → `[TODO: verify — is this actually true / supported?]`

A draft full of honest `[TODO]`s is a success. A smooth draft with invented facts is a failure the user won't
catch until a reviewer does. Say up front: "I'll draft only from what you give me and mark every gap."

## Step A — Gather inputs (ask for what's missing; don't proceed on vibes)

Collect and read the real materials before writing a sentence:
1. **Results / numbers** — a results table, CSV, wandb run, or the user's stated numbers. This is the spine of
   the claims. No results → you can draft structure and background, but flag every empirical claim as `[TODO]`.
2. **Code** — point at the repo/files. Use it to describe the method accurately (what the model/loss/loop
   actually does), and to ground the contribution. `phd-skills` (`/xray`) maps code↔paper — lean on it.
3. **Related papers** — pull real ones, don't recall them from memory:
   - `zotero-mcp` — the user's library + BibTeX (`zotero_search_*`, export BibTeX).
   - `arxiv` / `semantic-scholar` MCPs — find + fetch papers, get real metadata.
   - Every cited paper must come from one of these, never from the model's memory.
4. **Target + reader** — venue (arXiv/NeurIPS/…), section(s) to draft, and the reader level (expert reviewer /
   area chair skim / cross-field). Sets jargon and depth.

If a key input is missing, ASK. Drafting an empirical paper with no results is the classic fabrication trap.

## Step B — Plan the story FIRST (narrative.md), then draft

Do not start prose until the arc is set. Using narrative.md:
- Fix the **value** (what should the reader believe after; why they care) and the **OCAR arc**
  (problem → gap → approach → result → meaning).
- Write a one-line-per-section outline (the ghost-outline). Confirm with the user if the piece is > a few
  paragraphs. A wrong structure drafted fluently is wasted work.

## Step C — Draft section by section, from inputs only

Draft in the order that grounds claims before they're promised (Draft-0 trick from paper-writing-skill):
**Method + Results first** (closest to code/numbers) → **Related Work** (from the pulled papers) →
**Intro** (now you know what you can actually claim) → **Abstract last** (it promises exactly what the intro delivers).

For each section:
- Pull every fact from an input. Attribute as you go: numbers → the results source; method details → the code;
  prior work → the fetched paper (with a real citation key from Zotero, or a `[TODO: cite]`).
- Apply the writing craft while drafting, not after: claim-first sentences, one idea each, cut clutter
  (clarity.md), and the section's OCAR role (narrative.md). A grounded draft can still be clear from sentence one.
- **Contributions/claims must trace to results.** Don't write "we achieve state of the art" unless a number in
  the inputs shows it. If it's close but unconfirmed, write the honest version + `[TODO: confirm vs baseline X]`.
- Keep the user's voice and the field's value words (efficiency, generalization, …), not hype.

## Step D — Ground-check the draft before handing it back

Run the claim↔evidence map (audit.md) on your OWN draft:
- Every claim in intro/abstract maps to a result you actually used? Unmapped → `[TODO]` or cut.
- Every number matches its source? Every citation is a real pulled paper, not a guess?
- List all `[TODO]`s at the end as a checklist so the user sees exactly what's ungrounded.

Then hand off verification (don't claim it yourself): `phd-skills /factcheck` (citations vs DBLP),
`/xray` (numbers vs code/tables). Say: "drafted from your inputs; N open [TODO]s; run /factcheck + /xray before trusting the citations and numbers."

## What this mode is NOT
- Not a "generate a paper about topic X" button. No inputs → it asks, or writes only ungrounded structure with everything flagged.
- Not citation verification (phd-skills) or number auditing (/xray) — it drafts and flags; those tools confirm.
- Not for slides — that's research-deck.
