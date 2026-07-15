# Audit — how to review and fix a draft

The mechanics: how to turn the principles (clarity.md, narrative.md) into a concrete review a researcher can
act on. Borrows the best of the existing skills (enforcement tags, density scoring, Original/Recommended/Reason
cards, independent red-team) and adds the checks none of them do (value-to-reader, claim↔evidence).

## Order of the audit (structure first, always)

1. **Value + story pass** (narrative.md) — ghost-outline test, so-what test, McEnerney value reframe.
   If this fails, STOP and coach the structure. Do not proceed to word edits.
2. **Claim↔evidence pass** (below) — the highest-value ML check.
3. **Clarity pass** (clarity.md) — clutter, energy-drains, sentence length, given→new flow.
4. **Score, report, offer to fix.**

---

## The claim↔evidence map (the check no other writing tool runs)

For a paper draft (or intro+results), build a small table before editing prose:

1. Extract every CLAIM in the abstract + intro (contributions, "we show that…", performance assertions).
2. For each, find the RESULT (table/figure/section) that backs it.
3. Flag:
   - **Unbacked claim** — a claim with no result behind it → CRITICAL (reviewers attack this first).
   - **Buried result** — a result never promised up front → the abstract/intro is underselling; surface it.
   - **Number mismatch** — a number in the prose ≠ the number in the table/figure → CRITICAL, and never
     "fix" by inventing a number; flag it for the author to reconcile.

This is prose-side only — it finds the mismatch. To VERIFY the numbers/citations against code and DBLP, hand
off to `phd-skills` (`/xray`, `/factcheck`). Say so in the report.

---

## Density score (so one flaw doesn't fail a good draft)

Don't count raw hits — weight by severity and normalize, per slop-cop's method:

```
U = words / 500
density = ( CRITICAL×3  +  MAJOR×1  +  MINOR×0.25 ) / U
```

Tiers: **0–2 CLEAN · 2–5 LIGHT · 5–10 NEEDS WORK · 10+ REWRITE.**
Escalate one tier if: any unbacked claim (auto-CRITICAL), the ghost-outline test fails, or a paragraph has 3+
CRITICAL/MAJOR. Report the number and the tier so "this reads badly" becomes reproducible.

Compression signal: if fixing clutter cuts the passage >50%, that's not wordiness — the framing was wrong; flag
for a structural rethink, not just tightening.

---

## Report format (default output — do NOT mutate the file first)

Write a report, section by section. Each issue is a card:

```
### [CRITICAL · value] intro never says why the reader should care
Original:    In this paper, we present a method for online hint generation in GRPO.
Recommended: GRPO can't learn from tasks where every rollout fails — the exact hard tasks we care about. We fix that with online teacher hints.
Why:         value/story — leads with what we did, not the reader's problem (McEnerney; Swales Move 2 gap missing)
```

- **Severity:** CRITICAL (misleads reader / unbacked claim / no contribution / buried point) · MAJOR (clutter,
  weak structure, fails so-what, broken flow) · MINOR (word choice, rhythm, a stray passive).
- **Pillar tag:** value · story · clarity · sharpness (so the author sees which layer).
- `Recommended` is always a full sentence (the actual fix), never a fragment or "consider rephrasing".
- Each section starts with a 1-line count (e.g. "2 CRITICAL, 3 MAJOR"). Omit clean sections.
- End with: the **density score + tier**, then the **top 3 fixes** ranked by reader impact.
- Then ask: **"Want me to apply these?"** Apply only after the user says yes. Keep their voice; change the idea's clarity, not their style.

---

## Independent red-team (optional, for a full draft)

The author-agent rationalizes its own prose. For a high-stakes pass, spawn a SEPARATE reviewer subagent that
never saw the draft's self-assessment, give it clarity.md + narrative.md, and have it produce the report from
scratch. Trust "clean" only when the independent reviewer returns zero CRITICAL/MAJOR with the passages quoted.
(Same idea as phd-skills `/xray`; use that for the numbers, this for the prose.)

---

## Calibration — don't over-edit

- Flag by whether it hurts the READER, not by rule-matching. A passive in Methods, a long sentence that's
  genuinely one idea, a technical term the reviewer knows — all fine. Say so instead of flagging.
- Respect the reader level chosen in Step 0: jargon undefined for experts is correct; the same word is clutter
  for a cross-field reader.
- If a passage needs rethinking, say it plainly. Don't polish words in a paragraph that shouldn't exist.
- Never invent facts or numbers while "improving" prose. If a rewrite would change a claim, stop and ask.
