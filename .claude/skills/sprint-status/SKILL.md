---
name: sprint-status
description: Get current sprint status from Jira. Shows issues by status, blockers, and progress.
disable-model-invocation: true
---

Get the current sprint status from Jira.

## Process

1. Use Jira MCP to get the active sprint for the project
2. List all issues in the sprint grouped by status (To Do, In Progress, Done)
3. Identify blockers and high-priority items
4. Calculate progress percentage

## Output Format

```
Sprint: <name> | <start> - <end>
Progress: <done>/<total> (<percentage>%)

## Done
- [KEY] Description (assignee)

## In Progress
- [KEY] Description (assignee)

## To Do
- [KEY] Description (assignee)

## Blockers
- [KEY] Description — reason
```

If $ARGUMENTS contains a project key, use that. Otherwise, try to detect from the current repo.
