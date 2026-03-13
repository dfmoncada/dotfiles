Synchronize agents between Claude Code and OpenCode.

1. List agents in `~/.claude/agents/` and `~/.config/opencode/agent/`
2. Identify any that exist in one but not the other
3. For agents that exist in both, compare the body content (ignore frontmatter format differences)
4. Report discrepancies
5. If $ARGUMENTS contains "fix", automatically sync the body content keeping each platform's frontmatter format

Format reference:
- Claude Code: `tools`, `disallowedTools`, `model` (short: opus/sonnet), `memory`, `color` (name)
- OpenCode: `mode`, `model` (full ID), `color` (hex/semantic), `permission`, `tools` (write/edit booleans)
