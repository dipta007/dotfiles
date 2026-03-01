## Python / uv

1. Always use `uv` for Python. Never pip, poetry, or conda.
2. Run scripts with `uv run script.py`, not `python script.py`.
3. Add dependencies with `uv add <pkg>`, not `uv pip install`. Only use `uv pip install` if the user explicitly asks for it.
4. After implementing a feature, run it to verify it works before reporting completion.
5. After verifying a feature works, ask the user: "Should I add this as a pytest test so you can run it later?"

## Memory

After any substantial change (new feature, bug fix, architectural decision, new dependency, config change, or lesson learned), update the project-level memory files. Keep MEMORY.md concise and link to topic-specific files for details.

## Workflow Rules

1. **Local CLAUDE.md**: If the project has no local `CLAUDE.md`, create one with project-specific conventions. Local CLAUDE.md always overrides this global file on conflicts.
2. **Clarify first**: If anything about the task is confusing or unclear, use the AskUserQuestion tool to clarify before making any decisions or writing any code.
3. **Plan before coding**: Describe the approach and wait for explicit user approval before writing any code.
3. **Small scope**: If a task touches more than 3 files, stop. Break it into smaller subtasks and confirm the plan with the user.
4. **Risk awareness**: After writing code, list what could break and suggest tests to cover those risks.
5. **Learn from corrections**: When the user corrects a mistake, add a rule to the project's local CLAUDE.md so the same mistake never happens again.
