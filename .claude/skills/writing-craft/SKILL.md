---
name: writing-craft
description: "Use this skill whenever the user wants to improve the WRITING itself — prose quality, clarity, storytelling, cutting clutter, making dense technical text readable — for ML/AI research writing: paper drafts, abstracts, intros, related work, rebuttals, blog posts, README, grant text, or any passage they want to read better. Triggers: 'make this clearer', 'tighten this', 'edit my writing', 'is this well written', 'help me write the intro/abstract', 'cut the clutter', 'this reads badly', 'improve the prose', 'rewrite this paragraph', 'review my writing'. This governs the CRAFT of the words (clarity, story, value-to-reader, sharpness) — NOT file formatting (docx/latex), citations (phd-skills), or slides (research-deck). Grounded in Zinsser (On Writing Well), Schimel (Writing Science / OCAR), McEnerney (communicating value), Lanham (paramedic method), Williams, Gopen & Swan (given-new flow)."
license: MIT
---

# Writing Craft (ML/AI research)

Make research prose clear, well-structured, and valuable to the reader. This skill is about the
WORDS — not formatting, citations, or slides. It coaches and edits toward four pillars, in priority order:

1. **Value to the reader (McEnerney)** — does the text change what the reader thinks, in terms THEY care about?
2. **Story / structure (Schimel OCAR)** — is it a narrative (problem→gap→approach→result→meaning), not a data dump?
3. **Clarity & cut clutter (Zinsser + Lanham)** — every word earns its place; simple, direct, warm.
4. **Reviewer-facing sharpness** — claim-first sentences, the so-what test, claims backed by evidence.

**Read the three guides before editing:** [clarity.md](clarity.md) (word/sentence craft),
[narrative.md](narrative.md) (structure + value + sharpness), [audit.md](audit.md) (how to report/fix).

---

## Step 0 — Pick the mode (ask if unclear)

- **Coach / plan** — user is starting or stuck. Help find the story and value FIRST (narrative.md), before any prose. Don't polish words that shouldn't exist.
- **Revise** — user has a draft, wants it better. Run the audit (audit.md), produce an issue report, apply fixes on request.
- **Quick edit** — user pastes a paragraph, wants it tightened now. Give the improved version + a 1-line why per change. Skip the full report.

Also ask (if not obvious): **who is the reader?** (expert reviewer / area chair skimming / cross-field reader). This sets what jargon may go undefined and how much context to give. Everything downstream depends on it.

---

## Step 1 — Value and story BEFORE words (the part everyone skips)

Most "bad writing" is not word-level. It is that the text explains what the author DID instead of why the
reader should CARE. Fix this first — polishing a value-less paragraph is wasted work. From narrative.md:

- **The McEnerney test:** the value of the writing is not to record your ideas — it is to CHANGE the reader's.
  Ask: what does the reader believe now, what should they believe after, and why do THEY care? If the text
  only says "here is what we did", reframe around the reader's problem.
- **The so-what test:** for the abstract, intro, and every results paragraph — cover the claim, read it, ask
  "so what?". If there is no answer in the reader's terms, the point is not made yet.
- **OCAR / story arc:** problem (why this matters) → gap (what's missing/broken) → approach → result → meaning.
  Titles/topic-sentences alone should tell this arc (the ghost-outline test).

---

## Step 2 — Then the words (clarity.md)

Apply Zinsser + the paramedic method. The four highest-yield moves for ML prose:
- **Cut clutter** — inflated phrases ("in order to"→"to"), throat-clearing openers ("It is important to note that"→delete), padding, redundant adjectives.
- **Kill the three energy-drains** — passive voice, fuzzy verbs (is/makes/performs), nominalizations ("the regulation of"→"regulates"). Rewrite as actor→action→object.
- **One idea per sentence.** Break any sentence joining 3+ clauses. Simple words over fancy ones.
- **Given→new flow** — start each sentence with old/familiar info, end on the new idea; the new idea of sentence N becomes the familiar start of N+1. Broken chains are why paragraphs feel choppy.

Full rule lists with `[MECH]` (a grep/scan catches it) vs `[JUDGE]` (must be read for) tags are in clarity.md.

---

## Step 3 — Sharpness + claim↔evidence (audit.md)

The check no other writing tool does, and the one ML reviewers punish hardest:
- **Every claim maps to evidence.** Each contribution/claim in the abstract and intro must be backed by a
  result later. Flag claims with no backing, and results never mentioned up front.
- **Numbers match.** Numbers in the prose must match the tables/figures. Flag mismatches; do not invent.
- **Claim-first sentences.** Lead with the finding, then the detail ("X beats Y by 4 pts because …"), not "we ran an experiment where …".

---

## Report format (from audit.md — the default output)

Do NOT silently rewrite the user's file. Produce an issue report, section by section, each issue as a card:

```
### [SEVERITY · Pillar] short title
Original:    <the exact sentence/passage>
Recommended: <the concrete rewrite — a full sentence, not a fragment>
Why:         <one line + the principle, e.g. "clutter — Zinsser" / "value — McEnerney" / "unbacked claim">
```

- **Severity:** CRITICAL (misleads reader / unbacked claim / buried point) · MAJOR (clutter, weak structure, no so-what) · MINOR (word choice, rhythm).
- Lead each section with a 1-line summary (counts by severity). Omit sections with no issues.
- End with the **top 3 fixes** ranked by impact on the reader.
- Then offer: "want me to apply these?" — only mutate the text after the user says yes.

## Honest calibration (avoid over-editing)

- Not every passive is wrong (methods sections use it legitimately); not every long sentence is bad. Flag by
  whether it hurts the READER, not by rule-matching. Say when a "violation" is actually fine.
- Keep the author's voice. The goal is their idea, clearer — not your style.
- Match the reader level chosen in Step 0. Jargon a reviewer knows is fine; the same term is clutter for a cross-field reader.
- If a whole passage needs rethinking, say so plainly — don't polish sentences in a paragraph that shouldn't exist.

## Related tools (hand off, don't duplicate)
- **phd-skills** `/factcheck` `/xray` — citations vs DBLP, number/code audits. Writing-craft does PROSE; it flags claim↔evidence but phd-skills verifies the numbers.
- **research-deck** — for SLIDES, use research-deck, NOT this skill. See the boundary below.
- **slop-cop** (if installed) — a mechanical CLI prose linter; complementary to this skill's craft coaching.

## Slides are NOT prose — the boundary with research-deck

If the target is a slide deck, use **research-deck**, not this skill. Slides have no sentences or paragraphs,
so this skill's word/sentence rules (clarity.md) would make slides worse — walls of text instead of the
telegraphic fragments good slides use. What DOES carry over is only the structure layer, and research-deck
already has its own versions:
- value-to-reader → research-deck's "audience needs the why" + reader-level question
- OCAR story → research-deck's Problem→Gap→Method→Results→Takeaway spine
- so-what test → research-deck's **action titles** (title states the takeaway, not a topic)
- ghost-outline → research-deck's **ghost-deck test**

The ONLY slide elements that are sentence-like — and where this skill's clarity rules genuinely help — are the
**action titles** and the **speaker-note scripts**. research-deck already governs both. So: don't run this
skill's paragraph rules (given→new flow, topic sentences, one-idea-per-sentence, full-sentence polish) on slide
bullets. Improve the deck's PROSE artifacts (a blog version, the paper the talk is based on) with this skill;
build and word-tune the deck itself with research-deck.
