---
name: fix-issue
description: Pull a Jira issue, implement the fix, run tests, and create a PR. Pass the issue key as argument.
disable-model-invocation: true
context: fork
---

Fix Jira issue $ARGUMENTS.

## Process

1. **Get issue details** from Jira using MCP tools: read issue $0, understand requirements, acceptance criteria, and context
2. **Create branch**: `command git checkout -b fix/$0` (use issue key in branch name)
3. **Analyze codebase**: find relevant files, understand the current behavior
4. **Implement fix**: make minimal, targeted changes
5. **Write/update tests**: ensure the fix is covered
6. **Run tests**: verify nothing is broken
7. **Commit**: `command git add -A && command git commit -m "fix($0): <description>"`
8. **Create PR**: use the `/pr` skill format, reference the Jira issue

## Guidelines

- Read the full issue including comments before starting
- Make minimal changes — fix the issue, don't refactor unrelated code
- Include the Jira issue key in commit messages and PR title
- If the issue is unclear, list assumptions before proceeding
