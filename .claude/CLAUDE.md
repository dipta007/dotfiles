# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use your judgment. For anything non-trivial, follow these rules to avoid costly mistakes and rework.

## 0. Output Style (CRITICAL — applies to EVERY final answer)

**Final output MUST be: (1) concise but complete, (2) simple enough for a non-native English speaker.**

- Think as long as you want (reasoning tokens are free). This rule governs ONLY the final answer, not your thinking.
- **Concise but complete:** say everything that matters, nothing that does not. Cut filler, repetition, hedging. Do not drop needed steps, caveats, or context to be short.
- **Simple language:** short sentences (one idea each). Common words over fancy ones. Explain a needed technical term in a few plain words. No idioms, no rare vocabulary, no long clause-chains.
- Prefer lists, short tables, and short paragraphs over walls of text.
- If short and complete conflict, keep complete — then simplify the wording, not the content.
- This rule is NON-NEGOTIABLE and overrides any habit toward long or complex prose.

**Applies to written docs too, not just chat answers.** Any generated content or tech doc
(README, design doc, plan, notes, code comments) MUST be:
- **Simple** enough for a non-native English speaker.
- **Concise** enough that a busy researcher WANTS to read it.
- **Complete** enough that they miss nothing they need.
- EXCEPTION: research papers. For papers use the `writing-craft` skill or a paper-writing skill,
  NOT this rule.

**NO em-dash, ever (applies to ALL output).** Never use the em-dash character in any
generation: chat replies, papers, docs, README, slides, comments, commit messages, code,
anything. This has no exception.
- Do not just swap the em-dash for an en-dash or a spaced hyphen as a workaround. Rewrite the
  sentence so no dash is needed.
- Use a period, comma, colon, parentheses, or two short sentences instead. Pick the one that
  fits the meaning.
- Applies to visible text AND thinking output.
- The character to never emit is U+2014 (the long dash). Also avoid using U+2013 or a
  spaced hyphen as a stand-in for it.
- NOTE: the "Bad" lines below intentionally contain a real em-dash so the example is clear.
  This block is the ONLY place an em-dash is allowed. Do not copy the pattern; do not strip
  the em-dash from these examples either.
- Aside or interruption:
  - Bad: "The fix works — but only on macOS."
  - Good: "The fix works, but only on macOS." Or: "The fix works. It is macOS only."
- List set off mid-sentence:
  - Bad: "Three tools — fd, rg, fzf — cover search."
  - Good: "Three tools cover search: fd, rg, and fzf."
- Two clauses joined for emphasis:
  - Bad: "One rule matters most — verify."
  - Good: "One rule matters most: verify."

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. Comments

**Concise, human-coder-like, non-native-English voice. Simple but complete.**

Write comments the way a busy engineer writes them at 11pm — short, direct, slightly clipped. Skip articles ("the", "a") when the meaning is clear. Skip filler ("In order to", "Note that"). Don't write essays.

But: complete. The "why" must be there if it's non-obvious. Future-you must be able to understand the constraint without re-deriving it.

**Do:**
- One line if one line is enough.
- Lead with the fact: `Pool size 48 (NOT =num_workers): cheap CPU procs, batch >> workers...`
- Keep load-bearing context: incident references, version-specific gotchas, deadlock stories, magic numbers' origins. Future readers can't recover these from the code.
- Use sentence fragments where they read naturally: `# Empty → verl derives prompt+response.` is fine.

**Don't:**
- Don't restate what the code obviously does. `# increment counter` next to `i += 1` is noise.
- Don't write multi-paragraph block comments unless the user asks. Two short lines beat one paragraph.
- Don't pad with "Note:", "Important:", "Please". Just say it.
- Don't write polished marketing prose. This is a comment, not docs.
- Don't use em-dashes or polished transitions ("Furthermore", "Additionally", "However") to chain claims. Plain `.` or `;` is enough.

**Test:** Read the comment back. Does it sound like a tired engineer typed it, or like an essay? If essay, cut it.

When in doubt: shorter, plainer, complete. If it loses meaning, add it back. If it doesn't, leave it short.

## Visualization (CRITICAL — any chart, plot, figure, image, UI, HTML artifact)

**Before making ANY visualization, think about how the human eye and brain read it.** Design for perception first, decoration last.

- **Invoke the `dataviz` skill first** for any chart, graph, plot, dashboard, figure, or data viz. It encodes these principles. Do this BEFORE writing the first line of chart/UI code or picking colors.
- **Ground design in perception research.** Follow the ideas from the core visualization books, which are all about how humans perceive:
  - Colin Ware, *Information Visualization: Perception for Design* (how the eye/brain process visuals).
  - Edward Tufte, *The Visual Display of Quantitative Information* (maximize data-ink, cut chartjunk).
  - William Cleveland (position on a common scale is read most accurately; color/area least).
  - Cole Nussbaumer Knaflic, *Storytelling with Data* (one clear message per view, guide the eye).
- **Apply the key rules every time:**
  - Pick the chart type that matches the question, not the flashiest one.
  - Rank encodings by accuracy: position > length > angle > area > color/shade. Use the strongest one the data allows.
  - One main message per figure. Remove anything that does not help read it (extra gridlines, 3D, heavy borders, noise).
  - Order and group data to make the pattern obvious (sort bars, align baselines).
  - Use color with meaning, not for looks. Keep it colorblind-safe and readable in light and dark.
  - Label directly when you can. Keep legends short. Add units and a clear title.
  - Do not distort: bar charts start at zero; keep aspect ratios honest.
- If a viz book or the `dataviz` skill conflicts with these lines, the skill wins (it is kept current).

## Python / uv

1. Always use `uv` for Python. Never pip, poetry, or conda.
2. Run scripts with `uv run script.py`, not `python script.py`.
3. Add dependencies with `uv add <pkg>`, not `uv pip install`. Only use `uv pip install` if the user explicitly asks for it.
4. After implementing a feature, run it to verify it works before reporting completion.
5. After verifying a feature works, ask the user: "Should I add this as a pytest test so you can run it later?"

## Memory

After any substantial change (new feature, bug fix, architectural decision, new dependency, config change, or lesson learned), update the project-level memory files. Keep MEMORY.md concise and link to topic-specific files for details.

## Workflow Rules

1. **Local CLAUDE.md**: If the project has no local `CLAUDE.md`, ask the user if he wants to create one. Local CLAUDE.md always overrides this global file on conflicts.
2. **Clarify first**: If anything about the task is confusing or unclear, use the AskUserQuestion tool to clarify before making any decisions or writing any code.
3. **Plan before coding**: Describe the approach and wait for explicit user approval before writing any code.
4. **Small scope**: If a task touches more than 3 files, stop. Break it into smaller subtasks and confirm the plan with the user.
5. **Risk awareness**: After writing code, list what could break and suggest tests to cover those risks.
6. **Learn from corrections**: When the user corrects a mistake, add a rule to your memory so the same mistake never happens again.
7. **Never commit without explicit permission (CRITICAL)**: Do NOT run `git commit` unless the user explicitly tells you to commit in that request. Same for `git push`, `git merge`, and opening PRs. Staging changes or writing code is fine; creating the commit is not. If you think a commit is warranted, stop and ask first. A prior "yes" does not carry over to later changes; ask again each time.

**MOST CRITICAL:** Always ask for clarification when uncertain. Never assume. Never hide confusion. Always surface tradeoffs and options.
