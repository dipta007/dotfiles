# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use your judgment. For anything non-trivial, follow these rules to avoid costly mistakes and rework.

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
