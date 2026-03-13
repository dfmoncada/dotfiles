---
name: commit
description: Create a well-formatted commit with conventional commit message. Analyzes staged changes and generates appropriate message.
disable-model-invocation: true
---

Create a commit for the current changes.

## Process

1. Check status: `command git status`
2. Check diff: `command git diff --staged` (if nothing staged, `command git diff`)
3. If nothing is staged, stage all changes: `command git add -A`
4. Analyze changes and determine type:
   - `feat`: new feature
   - `fix`: bug fix
   - `refactor`: code restructuring
   - `test`: adding/updating tests
   - `docs`: documentation
   - `chore`: maintenance, deps, config
5. Create commit: `command git commit -m "<type>(<scope>): <concise description>"`

## Rules

- Message max 72 chars for first line
- Scope is optional but use when clear (e.g., auth, api, ui)
- Use imperative mood: "add" not "added"
- If $ARGUMENTS provided, use as context for the commit message
- Be extremely concise
