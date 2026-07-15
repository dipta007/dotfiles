# Narrative, value, and sharpness

Structure and reader-value — the part that matters MORE than word polish, and the part most tools skip.
Grounded in McEnerney (communicating value), Schimel (*Writing Science* / OCAR), Swales (CARS), and the
so-what test. Fix this layer FIRST; don't polish sentences in a paragraph that shouldn't exist.

---

## 1. Value to the reader (McEnerney) — the master idea

The purpose of research writing is NOT to record what you did. It is to **change what the reader thinks**,
about something the reader already cares about. Value is decided by the reader/community, not the author.

- **The reframe test:** does this passage say "here is what WE did" or "here is a problem YOU (reader) have,
  and here is what changes"? If the former, reframe around the reader's problem and interest.
- **Three questions for the abstract + intro:**
  1. What does the target reader believe now?
  2. What should they believe after reading?
  3. Why does that shift matter *to them* (not to you)?
- **Community codes:** frame the contribution in the words the field values — "efficiency", "sample
  efficiency", "generalization", "safety", "scalability". Not "we tried X and it worked". Name the value.
- **Kill the diary.** Chronological "first we did A, then B, then C" is author-order, not reader-value. Reorder
  to lead with what matters to the reader.

McEnerney's blunt version: readers are busy, skeptical experts. They don't read to understand you; they read
to find value for themselves. Writing that ignores this gets skimmed and rejected even when the work is good.

---

## 2. Story arc (Schimel OCAR) — structure above IMRaD

Two roots hold up everything: **OCAR** (structure) and stickiness (make the point land). When a rule feels
arbitrary, trace it back to these.

**OCAR = Opening · Challenge · Action · Resolution.** "IMRaD is a rule; OCAR is a principle." Applied
fractally — to the paper, each section, each paragraph:
- **Opening** — the setting + why the reader should care (the problem, in reader terms).
- **Challenge** — the specific gap / question / thing that's broken. This is the tension that pulls the reader.
- **Action** — what you did about it (only what's needed to read the result).
- **Resolution** — what you found, and what it MEANS. Close the loop back to the opening (a spiral, not a circle:
  end where you started but higher).

**The ML paper arc, concretely:** problem (why it matters) → gap (why existing methods fall short) →
approach (your idea in one picture) → result (the evidence) → meaning (what changes for the reader).

**Ghost-outline test:** read only the title + section headings + the first sentence of each section, in order.
They must tell the whole OCAR arc by themselves. If they don't, the structure is broken — fix that before prose.

**Openings (Swales CARS for intros):** Move 1 establish the territory (this matters) → Move 2 establish the
niche (but this is missing/wrong) → Move 3 occupy the niche (we do X, and find Y). A intro that skips Move 2
(the gap) leaves the reader asking "why are you telling me this?".

**Paragraph rule:** each paragraph makes ONE point, stated in its first sentence (the topic sentence). If you
can't say the paragraph's point in its opening line, the paragraph isn't decided yet.

---

## 3. Sharpness — reviewer-facing (the so-what + claim/evidence)

ML reviewers skim, are skeptical, and punish two things hardest: no clear contribution, and claims not backed
by results. This layer is graded in audit.md; the principles:

- **The so-what test.** For the abstract, intro, and every results paragraph: cover it, read the claim, ask
  "so what?". If there's no answer *in the reader's terms*, the point isn't made. Add the meaning or cut it.
- **Claim-first sentences.** Lead with the finding, then the mechanism/detail. "Nudging cuts convergence time
  ~2× by creating signal on all-fail groups" — not "We ran an experiment in which we added hints and observed…".
- **Every claim maps to evidence** (see audit.md §claim-map). Each contribution in the abstract/intro must be
  backed by a result. A claim with no backing is a reviewer's first target.
- **One argument, made well.** Don't cram every result. Pick the claim you can prove convincingly; the rest is
  supporting or appendix. A paper that argues one thing clearly beats one that lists five things weakly.
- **Abstract shape (4-6 sentences):** context (1) → gap (1) → what we do (1) → key result with a number (1-2) →
  why it matters (1). If the abstract has no number, it's usually too vague.
- **Address the obvious objection.** A skeptical reader has a "but what about…" — name the main limitation
  before they do ("but, yes" framing: acknowledge the limit, then why the contribution still holds).

---

## 4. When to coach vs. edit

- If the ghost-outline doesn't tell the arc, or the so-what test fails → this is a STRUCTURE problem. Coach the
  author to fix the story/value first (Steps 1-3). Word edits come after.
- If the arc is sound but the prose is dense/cluttered → go to clarity.md and audit.md.
- Never bury a structural problem under sentence polish. Say plainly: "the words are fine, but the paragraph
  doesn't answer 'so what?' — let's fix that first."
