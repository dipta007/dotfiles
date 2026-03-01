---
name: test-it
description: Test the last implemented feature, then ask if it should be added as a pytest test. Use after implementing any feature or change.
disable-model-invocation: true
argument-hint: [optional: specific file or feature to test]
---

Test the most recent feature or change, then offer to persist it as a pytest test.

## Process

### Step 1: Identify what to test
- If `$ARGUMENTS` is provided, test that specific file/feature.
- Otherwise, check recent git changes (`git diff`, `git status`) to identify what was just implemented.

### Step 2: Run it
- Use `uv run` to execute the relevant code.
- If it's a script, run it with sample inputs.
- If it's a function/module, write a quick inline test and run it.
- If there are existing tests, run `uv run pytest` on relevant test files first.

### Step 3: Report results
Clearly state:
- What was tested
- Whether it passed or failed
- If failed: what went wrong, with the full error

### Step 4: Fix if broken
If the test fails, debug and fix the issue. Re-run until it passes.

### Step 5: Ask about pytest
After the feature works, ask the user:

> "This feature is working. Should I add a pytest test for it so you can run it anytime later?"

If they say yes:
- Create the test in the appropriate `tests/` directory
- Follow existing test patterns in the project if any exist
- Use `uv run pytest <test_file> -v` to verify the test passes
- Use descriptive test names that explain what's being tested

### Step 6: Ask about Makefile
After adding the pytest test, check if a `Makefile` exists in the project root.
- If a Makefile exists but has no test command for this, ask the user:
  > "There's a Makefile but no test command for this. Should I add one?"
- If no Makefile exists, skip this step.
