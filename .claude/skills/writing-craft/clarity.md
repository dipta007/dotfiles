# Clarity & cutting clutter

Word- and sentence-level craft. Grounded in Zinsser (*On Writing Well*), Lanham (paramedic method),
Williams (*Style*), Gopen & Swan (given-new). Each rule is tagged:
- `[MECH]` — a grep/scan can catch a candidate (still needs a human to confirm it's really wrong).
- `[JUDGE]` — no pattern catches it; must be READ for.

The Zinsser core, in one line: **simplicity, clarity, brevity, humanity. Cut every word that does no work.**
A sentence is clean when nothing can be removed without losing meaning.

---

## 1. Clutter — cut it `[MECH]` for the lists, `[JUDGE]` for padding

**Inflated phrases → short form:**
- in order to → to · due to the fact that / owing to the fact that → because · in the event that → if
- a majority of → most · a number of → many/several · at this point in time → now · in the near future → soon
- has the ability to → can · is able to → can · make use of / utilize → use · in terms of → (usually delete)
- with regard to / with respect to → about/for · a large proportion of → many · it is often the case that → often

**Throat-clearing openers → delete (start with the point):**
- "It is important to note that …" · "It is worth mentioning that …" · "It should be emphasized that …"
- "In this paper, we …" (often trimmable) · "As mentioned above/previously …" · "Needless to say …"
- "It is well known that …" (either cite it or cut it)

**Padding words that rarely earn their place `[JUDGE]`:** very, quite, rather, somewhat, really, actually,
basically, essentially, fairly, in some sense, to some extent, arguably, clearly, obviously, of course.
(Cutting "very" usually makes the sentence stronger, not weaker.)

**Redundant adjective/noun pairs `[JUDGE]`:** "important role", "key factor", "novel approach" (show it's
novel, don't assert it), "significant improvement" (give the number), "detailed analysis".

---

## 2. The three energy-drains — rewrite actor→action→object

The most common reason ML prose feels flat. Fix template: put the DOER first, a strong VERB next, the target last.

- **Passive voice `[MECH]`** (was/were/is/are/been + past participle): "the loss was reduced by the auxiliary
  term" → "the auxiliary term reduces the loss". *Exception:* passive is fine when the doer is unknown or
  irrelevant, common and acceptable in Methods ("samples were normalized"). Flag by whether hiding the actor
  hurts the reader.
- **Fuzzy verbs `[JUDGE]`** (is, are, makes, performs, conducts, provides, utilizes): replace with the real
  action. "our method performs an improvement of" → "our method improves".
- **Nominalizations / zombie nouns `[MECH]`** (verbs turned into nouns, often -tion/-ment/-ance/-ing): "we
  perform the estimation of" → "we estimate"; "the regulation of X by Y" → "Y regulates X"; "make an
  adjustment to" → "adjust". Grep candidates: "the .* of", "-tion of", "performs the".

---

## 3. Sentences — one idea, short, direct

- **One idea per sentence `[JUDGE]`.** Break any sentence that joins 3+ clauses with and/but/which/so/;.
  The reader can hold "A, and B." They lose "A, and B, but C, which D."
- **Long-sentence flag `[MECH]`:** >30 words = check; >40 words = almost always split.
- **Simple words over fancy `[JUDGE]`:** demonstrate→show, utilize→use, leverage→use, facilitate→help,
  methodology→method (usually), elucidate→explain, endeavor→try. (Technical terms stay — GRPO, gradient,
  ablation. This is about the *non*-technical words.)
- **Positive over negative `[JUDGE]`:** "does not have" → "lacks"; "did not remember" → "forgot".
- **Concrete over abstract `[JUDGE]`:** name the thing. "performance improvements" → "+4.2 BLEU".

---

## 4. Given→new flow (the choppiness fix) `[JUDGE]`

From Gopen & Swan / Williams. Reader-comprehension, not grammar.
- **Topic position (start of sentence)** = old/familiar info. Never open with a brand-new term.
- **Stress position (end of sentence)** = the new idea / the key term you want remembered.
- **Flow rule:** the new idea at the end of sentence N should become the familiar start of sentence N+1
  ("reach back and grab"). stress→topic linking = a story; topic→topic repetition = a flat list.
- **Detection heuristic:** read the first noun phrase and last noun phrase of consecutive sentences. If
  sentence N+1 opens on something never introduced, the chain is broken — that's why the paragraph feels jumpy.

---

## 5. The Lanham paramedic method (fast clutter pass on one sentence)

1. Circle the prepositions (of, in, to, for, with, by…). Each is a place clutter hides.
2. Circle the "is/are/was/were" forms.
3. Find the real action — who is kicking whom?
4. Put the doer at the front, the action in a strong verb.
5. Cut what's left that does no work. Start fast (no long windup).

---

## De-AI note (light)
Cut the tells that also happen to be clutter: em-dash clusters as connectors, "not just X, but Y"
scaffolding, "it's worth noting", listicle transitions ("Furthermore, Moreover, Additionally"),
sycophantic openers. These overlap the clutter rules above — no separate pass needed. (For a dedicated
mechanical AI-tell linter, `slop-cop` / `avoid-ai-writing` exist; this skill treats it as part of clutter.)
