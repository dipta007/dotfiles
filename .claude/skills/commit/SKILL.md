---
name: commit
description: Read staged files and write a concise commit message for user approval.
disable-model-invocation: true
---

Create a commit message for currently staged changes, get user approval, then commit.

## STRICT RULES

**You may ONLY run these git commands:**
- `git diff --cached` (read staged changes)
- `git diff --cached --name-only` (list staged file names)
- `git commit -m "..."` (commit after approval)

**You may NOT run any of these:**
- `git add`, `git rm`, `git mv`
- `git reset`, `git restore`, `git checkout`
- `git stash`, `git clean`
- Any command that adds, removes, unstages, or changes the status of files

Do not touch the working tree or staging area. Read only, then commit only.

## Process

### Step 1: Read staged changes
Run `git diff --cached --name-only` to see what files are staged.
If nothing is staged, tell the user:
> "Nothing is staged. Stage your changes with `git add` first, then run `/commit` again."
Then stop.

### Step 2: Read the diffs
Run `git diff --cached` to read the actual changes.

### Step 3: Write a commit message
Write a concise, helpful commit message:
- First line: imperative mood, under 72 chars, summarizes the "what and why"
- If needed, add a blank line then a short body with context (2-3 lines max)
- Focus on WHY the change was made, not just what changed
- No fluff, no over-explaining

### Step 4: Show and ask
Present the commit message to the user and ask:
> "Commit with this message? (or tell me what to change)"

### Step 5: Commit
Only after explicit user approval, run `git commit` with the approved message.
If the user suggests edits, revise and ask again.
