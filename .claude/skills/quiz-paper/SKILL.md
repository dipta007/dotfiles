---
name: quiz-paper
description: Turn reading an arxiv paper into a Predict-then-Reveal game where curiosity, not points, is the reward. Claude reads the paper silently, then asks you to predict answers before revealing them, one question at a time, with rising difficulty. Use when the user wants to ENJOY reading a paper, be quizzed on it, learn it actively, or "make reading this fun" instead of getting a summary dumped at them. Triggers on "quiz me on this paper", "make me read this", "test me on arXiv 1234.5678", "gamify this paper", "help me actually learn this paper". Do NOT use for a passive summary (use skim:story/skim:deep) or an adversarial critique (use socratic).
argument-hint: <arxiv-id-or-url>
---

# quiz-paper: the Predict-then-Reveal reading game

## Why this exists (read before running)

Dumping a summary at a reader is the weakest way to teach a paper, and bolting XP/points on
top can make it worse. This skill is built on verified motivation and learning science, not on
game-feel intuition. The design rules below are load-bearing. Do not "improve" the game by
adding points, levels, or streaks. That was tried and rejected for cause.

**The four findings this game runs on:**

1. **Curiosity is itself a reward.** An open information gap ("I want to know the answer")
   activates the brain's dopamine reward circuit (Loewenstein 1994; Kang 2009; Gruber 2014).
   So the REVEAL is the prize. No external points needed. This is the engine.
2. **Feedback delivery flips its sign.** The same positive feedback helps when *informational*
   ("here's the piece you missed, here's why it matters", d=+0.66) and HURTS when *controlling*
   ("you scored 60, level 2", d=-0.44) (Deci, Koestner & Ryan 1999). Always give informational
   feedback. Never a bare score.
3. **Active recall beats re-reading** for memory (Roediger & Karpicke 2006). Making the reader
   retrieve/predict before the reveal is the whole point. Do not just tell them.
4. **Autonomy raises motivation; control kills it** (Self-Determination Theory). Imposed
   deadlines and coercive streaks push motivation "external" and reduce it. Let the reader
   steer: focus, depth, skip, go deeper, stop.

**Do NOT use (these claims were checked and refuted or unsupported):**
- No XP, points, levels, streaks, or scores. Points are the controlling-feedback trap (rule 2)
  and streaks thwart autonomy (rule 4).
- Do not claim the curiosity gap helps memory of surrounding details (refuted). Curiosity
  reliably helps memory only for the SPECIFIC answer the reader wanted. So the reveal must
  answer the exact thing you asked them to predict.
- Do not justify anything with a "Zeigarnik urge" (fails to replicate).

## The pipeline

### 0. Verify the paper exists (guard against hallucination)
Extract the arxiv id (`NNNN.NNNNN`) from the argument. Call the arxiv MCP `get_abstract` on it.
Confirm the title + authors with the user in ONE line. If the id does not resolve, stop.

### 1. Let the reader steer (autonomy)
Ask two quick choices in a single short message (use AskUserQuestion or plain text):
- **Focus:** whole paper / method only / results only / find-the-weak-spots
- **Depth:** quick (~5 beats) / standard (~8) / deep (~12)

### 2. Silent prep (never shown to the reader)
Download and read the paper (curl the PDF to /tmp, Read it; or use the arxiv MCP
`download_paper` + `read_paper`). Build a private plan you keep to yourself:
- The 3-5 facts/claims to quiz, ordered easy to hard.
- For standard/deep: silently find the paper's 1-2 real weak spots and check ONE headline
  number, to ground the hardest beats. Do this quietly. Do not narrate your prep.
- Curiosity needs a footing: note the one line of context each question needs so the gap
  actually bites (a reader feels no gap about something they know nothing about).

Keep ALL of this hidden. Revealing it defeats the game.

### 3. Run the loop, ONE beat per message
Each beat:
1. **Seed:** one line of context. Just enough to make the gap real, not the answer.
2. **Open the gap (predict first):** ask them to predict/reason BEFORE you reveal. Frame it as
   something worth wanting to know. Example: "It's a 7B model. Before I tell you: did it beat
   the 32B baseline in-domain, out-of-domain, or both? What's your guess and why?"
3. **Wait for their answer.** Do not answer your own question.
4. **Reveal = reward:** confirm or correct with INFORMATIONAL feedback. Name what they got
   right, the ONE key piece they missed, and why it matters. The reveal must answer the exact
   thing you asked them to predict. Cap at ~3 lines. Never a score, never "correct/level up".
5. If they are close, give ONE hint and let them retry before revealing (keeps flow).

**Rising difficulty** (curiosity framing, not a locked gate):
- recall ("what did it do?") -> comprehension ("why does that work?") -> evidence ("does that
  number actually support the claim?") -> **the weak spot / boss** ("if you were reviewer 2,
  what would you attack here, and what's the cheapest experiment to settle it?").

**Autonomy at every beat:** the reader may skip, ask to go deeper, or stop. Honor it.

### 4. Close (competence + small wins, no score)
End with a 3-line "what you now understand", assembled from THEIR OWN answers during the game
(this signals growing competence, which is the motivating kind of feedback). Add ONE thing
worth a second look later. No totals, no XP, no "you reached level 3".

## Output style (non-negotiable)
- Every turn is tiny: one question, or a short reveal. Never a wall of text.
- Simple, plain language. Short sentences. No em-dash.
- The reader does the thinking. You open gaps and reveal. You do not lecture.

## Scope
One paper per invocation, run in the chat. No files written, no persistence, no scoring.
For a passive summary use `skim:story` / `skim:deep`. For an adversarial critique of the
paper's claims use `socratic`.
