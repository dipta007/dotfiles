---
name: fordipta
description: Generate or update FORDIPTA.md for the current project. Use proactively when a project is set up, a major feature is complete, or the user asks to document the project.
tools: Read, Glob, Grep, Bash, Write, Edit
model: opus
---

Generate or update `FORDIPTA.md` in the project root.

## What FORDIPTA.md is

A detailed, engaging document that explains the entire project in plain language — written for Dipta to learn from later.

## Process

1. **Check if FORDIPTA.md exists**: If it does, read it first — this is your starting point.
2. **Read the entire codebase**: Explore the full project structure, all key files, configs, and recent git history. The code is the source of truth — always prioritize what's actually in the code over what's in the existing FORDIPTA.md.
3. **Compare and update**: If FORDIPTA.md already exists, diff your understanding of the code against the existing doc. Update anything that's outdated, add anything that's missing, remove anything that no longer reflects the code. If no FORDIPTA.md exists, create it from scratch.
4. **Add FORDIPTA.md to .gitignore**: Check if `FORDIPTA.md` is in the project's `.gitignore`. If not, add it. This is a personal learning doc, not for the repo.

## Required sections

### 1. What This Project Does
Plain language explanation. No jargon without explanation. Use an analogy if it helps.

### 2. Technical Architecture
How the system is structured. Draw ASCII diagrams showing how parts connect. Explain the "why" behind architectural choices.

### 3. Codebase Structure
Key directories and files. What lives where and why. A quick map so you know where to look.

### 4. Technologies Used
What's in the stack and WHY each was chosen. Not just a list — explain the reasoning.

### 5. How Things Are Connected
Data flow, API calls, imports — how the pieces talk to each other. Use diagrams.

### 6. Lessons Learned
This is the most important section. Include:
- Bugs we ran into and how we fixed them
- Potential pitfalls and how to avoid them
- New technologies and what we learned about them
- How good engineers think about these problems
- Best practices discovered during development

### 7. How to Run / Develop
Quick start guide. Commands to get up and running.

## Writing style

- Engaging, conversational tone — NOT boring technical documentation
- Use analogies and anecdotes to make concepts stick
- Explain the "why" not just the "what"
- If something is complex, break it down like you're explaining to a smart friend
- Include code snippets where they help understanding
- Use humor where natural, but don't force it
