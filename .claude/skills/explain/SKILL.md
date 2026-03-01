---
name: explain
description: Explain code, concepts, or architecture with analogies, diagrams, and a conversational tone. Use when the user asks "how does this work?", "what does this do?", or "explain this".
argument-hint: <file, function, concept, or code snippet>
---

## Process

### Step 0: Check for arguments
If no `$ARGUMENTS` is provided, respond with:
> "Usage: `/explain <file, function, or concept>`
> Examples:
> - `/explain src/auth/login.py`
> - `/explain the reward function`
> - `/explain how GRPO training works in this project`"

Then stop. Do not proceed without arguments.

### Step 1: Read the target
If it's a file or function, read it thoroughly. If it's a concept, gather context from the codebase.

### Step 2: Check dependencies (only if needed)
If the target file imports or depends on other files that are essential to understanding it, briefly explain those too. But ONLY if without them the target makes no sense. Do not explain every import — just the critical ones.

### Step 3: Explain it clearly
Follow the structure below.

## Explanation structure

### Start with an analogy
Compare the code/concept to something from everyday life. This anchors understanding before diving into details.

> "Think of this like a restaurant kitchen — orders come in (requests), the chef (controller) delegates to stations (services), and plates go out (responses)."

### Show the big picture
Draw an ASCII diagram showing how this piece fits into the system. Show data flow, relationships, or architecture.

```
[Input] → [Parser] → [Validator] → [Processor] → [Output]
                          ↓
                    [Error Handler]
```

### Walk through the code
Go step-by-step through what happens. Use plain language. Reference specific line numbers.

### Highlight the clever parts
What's the interesting design decision here? Why was it done this way and not another?

### Point out gotchas
What's a common mistake or misconception? What would trip someone up?

### Connect it back
How does this relate to broader programming concepts or patterns? What can be learned from this approach?

## Writing style

- Conversational, like explaining to a smart friend over coffee
- Use analogies freely — they make things stick
- Don't skip the "why" — understanding intent matters more than syntax
- If something is genuinely complex, say so — then break it down layer by layer
- Use code snippets to illustrate, but don't just dump code without explanation
- **Keep it concise**: The explanation should be SHORTER and FASTER to read than the code itself. If reading the code would be quicker, the explanation is too long. Cut ruthlessly. Focus on insight, not narration.
