Check that all MCP servers and key services are responding.

## Process

1. **Jira MCP**: Try listing projects via Jira MCP tools. Report success/failure.
2. **GitHub MCP**: Run `command gh auth status` to verify GitHub CLI auth.
3. **Telegram MCP**: Try sending a test message "health check ok" (or just verify the server is loaded).
4. **Memory MCP**: Try reading entities to verify the memory server responds.
5. **Docker**: Run `docker ps --format "table {{.Names}}\t{{.Status}}"` to check running containers.
6. **Git**: Run `command git status` to verify repo state.

## Output

```
## Health Check

| Service     | Status | Notes          |
|-------------|--------|----------------|
| Jira MCP    | ✅/❌  | [detail]       |
| GitHub CLI  | ✅/❌  | [detail]       |
| Telegram    | ✅/❌  | [detail]       |
| Memory MCP  | ✅/❌  | [detail]       |
| Docker      | ✅/❌  | X containers   |
| Git         | ✅/❌  | branch: X      |
```

If any service is down, suggest how to fix it.
