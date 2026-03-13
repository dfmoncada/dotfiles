---
name: notify
description: Send a notification via Telegram. Use after completing important tasks, creating PRs, or when something needs attention.
user-invocable: true
---

Send a Telegram notification using the telegram MCP server.

If $ARGUMENTS is provided, use it as the message content.
Otherwise, summarize what was just accomplished and send that.

Keep messages concise. Include:
- What was done
- Any relevant links (PR URLs, issue numbers)
- Status (success/failure/needs attention)
