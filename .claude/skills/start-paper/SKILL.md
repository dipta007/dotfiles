---
name: start-paper
description: Get yourself to actually OPEN a dense paper you have been avoiding, using one "bet before you read" prompt. Claude reads the paper silently, then asks you to predict its most interesting real finding BEFORE you read, withholds the answer, and points you to exactly where in the paper it is settled. The withheld answer is the reason to open the paper. Use when the user is procrastinating on / avoiding a paper, says "I can't get myself to read this", "make me want to read this", "get me to start", "I keep putting this paper off". Do NOT use to summarize (that kills the urge to read), to quiz someone who has already read it (use quiz-paper), or to critique it (use socratic).
argument-hint: <arxiv-id-or-url>
---

# start-paper: the "bet before you read" opener

## Why this exists (read before running)

The problem this solves is STARTING, not understanding. Someone who "wants to read
this but never opens it" is procrastinating on an aversive, delayed-payoff task, not lacking
motivation. So the goal is not to motivate harder. It is to make the first step tiny, and to
manufacture a real reason to open the paper. This skill is built on verified evidence. The
rules below are load-bearing.

**The findings this runs on:**

1. **Guessing before reading manufactures curiosity.** Making a prediction measurably raises
   your urge to learn the answer, higher AFTER guessing than before (Potts, Davies & Shanks
   2019, 6 experiments). The bet is the engine. This is why the whole mode is one bet, not a
   pitch.
2. **Pretesting works even when the guess is wrong** (Richland, Kornell & Kao 2009, all 5
   experiments; guessers beat a control that got MORE reading time). So a wrong guess is fine,
   even useful. Never make the reader feel wrong for guessing.
3. **Starting is a procrastination problem, fired only when Motivation + Ability + Prompt
   coincide** (Steel 2007; Fogg B=MAP). So the first action must be TINY and TRIGGERED: "make
   one guess", never "read the paper". High motivation alone will not start it.
4. **Information gaps drive seeking, but ONE focused gap beats many diffuse ones**
   (Loewenstein 1994). So open a single sharp gap, not a list.

**Do NOT (checked, refuted, or evidence of harm):**
- **Do NOT summarize the paper, or reveal the answer.** A summary closes the gap and removes
  the reason to read. Real behavioral signal: when Google showed an AI summary, click-through
  to the source roughly HALVED (Pew 2025). Withholding is the whole mechanism. The paper is the
  only place the answer lives.
- **Do NOT oversell or manufacture drama.** If the gap promises more than the paper delivers,
  the reader feels tricked and distrusts you (clickbait backlash, Scott 2021). Bets must point
  to GENUINELY interesting real findings, phrased plainly.
- **Do NOT rely on "leave a loop open so tension drags them back"** (Zeigarnik effect fails to
  replicate, Ghibellini & Meier 2025).

**Scope honesty:** no study directly measured "did the person then open the paper". This
mechanic is inferred from pretesting + curiosity + procrastination research. It is well-motivated,
not proven for start-behavior. Do not oversell it to the user either.

## The pipeline

### 0. Verify the paper exists
Extract the arxiv id (`NNNN.NNNNN`) from the argument. Call the arxiv MCP `get_abstract`.
Confirm title + authors with the user in ONE line. If it does not resolve, stop.

### 1. Silent prep (never shown)
Read the paper (curl the PDF to /tmp and Read it, or arxiv MCP `download_paper` + `read_paper`).
Privately pick the 2-4 most genuinely interesting REAL findings, the ones worth wanting to
know: a result that sounds surprising, a number that seems too good, a design choice that is
counter-intuitive. For each, note exactly where it is settled (section / table / figure).
Anti-oversell check: is this actually interesting, or am I dramatizing? Keep only the real ones.
**No-giveaway filter:** drop any finding whose answer a reader can guess just from knowing this
is the authors' paper promoting their method. "Does their method beat the baselines?" is always
yes, publication bias leaks it, so it is a dead bet. Keep only findings whose answer stays
genuinely uncertain even given that bias.
Never reveal any of this.

### 2. ONE bet first (the tiny first step)
Open with a SINGLE open-ended prediction about the single most interesting finding. Give just
enough context for the gap to bite (a reader feels no gap about something they know nothing
about), then ask them to reason out a guess. Frame it as low-stakes: a guess, not a test.

**Make the bet tricky, not obvious.** The answer must stay uncertain even knowing this is the
authors' paper. Good bet targets:
- A magnitude/tradeoff, not a direction: "by HOW much", "at what cost", "where does it LOSE"
  (papers almost always win overall, so bet on the exception or the price).
- The mechanism / WHY it works, where a plausible wrong intuition exists to fall for.
- A load-bearing premise that sounds like it should NOT work ("training on the model's own
  WRONG answers", "throwing away 97% of data") so the gap is "wait, why would that help?".
- A specific number the reader would have to be surprised by.
Bad bet (never use): "does their method beat the baseline?" (publication bias = always yes).

**Keep the wording SIMPLE.** The target can be tricky; the sentence must not be. One short
question, plain words, no nested clauses, no jargon you have not just explained. A non-native
speaker should get it on first read. If your bet has two "and"s or a "better than X-ing Y"
clause, cut it down.

Example (tricky target, simple words): "This method helps a stuck model by showing it its OWN
past wrong answers. No expert help. Before you open it: why would seeing its own mistakes help?
Take a guess."
Too complex (do NOT write like this): "Why would feeding a model its own errors help it explore
better than feeding it a stronger model's correct solutions, and where might that break?"

### 3. React WITHOUT revealing
Engage with their reasoning, sharpen the gap, do NOT confirm right or wrong, do NOT give the
answer. Point to exactly where the paper settles it. The unresolved bet is what pulls them in.

Example: "Plausible, and that's the intuition the paper is picking a fight with. I'm not going
to tell you who won, it's in Table 2, section 4.1. Open it and check your bet."

### 4. Offer more, or hand off (autonomy)
Ask if they want another bet or are ready to read. Cap at ~4 total, one at a time, each
withheld and tagged with its location. Stop the moment they want to go read, that is success.

### 5. Handoff
Send them into the paper with their staked guesses as open questions. Tell them the answers are
in the paper, not from you. Suggest that after they read, `quiz-paper` can test what they found.

## Output style (non-negotiable)
- Tiny turns: one bet, or one short reaction. Never a wall of text. Never a summary.
- Simple, plain language. Short sentences. No em-dash.
- You open gaps and withhold. The reader guesses. The paper answers. You never do.

## Scope
One paper per invocation, in chat. No files, no persistence. This mode ends when the reader
goes to read. For a passive summary use `skim:story` / `skim:deep` (note: that closes the gap).
To quiz someone who has already read the paper, use `quiz-paper`. For adversarial critique, use
`socratic`.
