---
name: mantra
description: Fetch Dipta's saved prompts from his private prompt library via the `mantra` CLI. Use when he refers to a prompt he already has rather than describing one from scratch: "use my paper reviewer prompt", "my commit message prompt", "what prompts do I have for X", "grab my rebuttal prompt", "the prompt I use for Y". Also use when a task obviously matches something he would have saved (reviewing a paper, writing a commit, a rebuttal) and it is worth checking before writing a prompt from nothing.
---

# mantra

Dipta's private prompt library, at `mantra.roydipta.com`. The `mantra` command reads it from the terminal.

## Commands

```bash
mantra                              # list every prompt: slug, category, use count, variable count
mantra search <words...>            # list prompts matching ALL the words
mantra <slug>                       # print the prompt body
mantra <slug> -v name=value         # fill {{variables}} first, repeatable
mantra <slug> --json                # the full record, including notes and version
```

`*` in the first column means pinned. `{{2}}` means the prompt has 2 variables to fill.

## How to use it

**Start with `mantra` or `mantra search`.** You will rarely know the exact slug, and the list is short enough to read.

**Then fetch and use the body directly.** Do not paraphrase a stored prompt: he saved that exact wording on purpose. Use it verbatim as the instruction for the task.

**Fill the variables.** If `mantra <slug>` prints anything of the form `{{name}}`, that is a blank you are expected to fill from context, using `-v name=value`. The CLI warns on stderr about any left unfilled. Never leave one in the final text: an unfilled `{{name}}` reaching a model is a broken prompt. If you cannot work out a value from context, ask him.

## What it cannot do

**Read-only, by design.** The credential is an Access service token that the server refuses for every write. So:

- Cannot add, edit, delete, or pin a prompt.
- If he wants to save a new prompt, tell him to add it at `mantra.roydipta.com`. Do not attempt an API write; it will return `403`.

## When something fails

| Message | Meaning |
|---|---|
| `missing credentials` | `CF_ACCESS_CLIENT_ID` / `CF_ACCESS_CLIENT_SECRET` are not in the environment. They live in his `~/.config/bashrc/secret`, so a shell that did not source it will not have them |
| `did not return JSON` | the service token was rejected or expired. He needs to rotate it in Zero Trust |
| `cannot reach` | network, or the Worker is down |
| `no prompt named "x"` | wrong slug. Run `mantra` and pick from the list |

Report the failure and move on. Do not invent a prompt and present it as one of his.
