## Python / uv

1. Always use `uv` for Python. Never pip, poetry, or conda.
2. Run scripts with `uv run script.py`, not `python script.py`.
3. Add dependencies with `uv add <pkg>`, not `uv pip install`. Only use `uv pip install` if the user explicitly asks for it.
4. After implementing a feature, run it to verify it works before reporting completion.
5. After verifying a feature works, ask the user: "Should I add this as a pytest test so you can run it later?"

## MUST FOLLOW RULES FOR ALL PROJECTS

For every project, write a detailed FORDIPTA.md file that explains the whole project in plain language. 

Explain the technical architecture, the structure of the codebase and how the various parts are connected, the technologies used, why we made these technical decisions, and lessons I can learn from it (this should include the bugs we ran into and how we fixed them, potential pitfalls and how to avoid them in the future, new technologies used, how good engineers think and work, best practices, etc). 

It should be very engaging to read; don't make it sound like boring technical documentation/textbook. Where appropriate, use analogies and anecdotes to make it more understandable and memorable.

## Important Guidelines
1. If local CLAUDE.md file doesn't exist, create it using \init command.

2. If there is conflict between local CLAUDE.md and global CLAUDE.md, local CLAUDE.md always takes precedence.

3. Before writing any code, describe your approach and wait for approval. Always ask clarifying questions before writing any code if requirements are ambiguous.

4. If a task requires changes to more than 3 files, stop and break it into smaller tasks first.

5. After writing code, list what could break and suggest tests to cover it.

6. Every time I correct you, add a new rule to the local CLAUDE.md file so it never happens again.
