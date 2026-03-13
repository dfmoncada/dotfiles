---
name: self-improve
description: Improve Claude Code performance by managing CLAUDE.md instructions, MCP servers, skills, hooks, and settings. Use when reflecting on session quality, when a workflow could be automated, or when the user asks to improve Claude's setup.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Self-Improvement Skill

Analyze the current session or a specific pain point, then take concrete action to improve future Claude Code sessions. Actions include:

## What to improve

1. **CLAUDE.md instructions** (`~/.claude/CLAUDE.md`, `.claude/CLAUDE.md`, or host-specific files under `~/.claude/host/`)
   - Add patterns learned during this session (coding conventions, project structure, common pitfalls)
   - Remove instructions that are outdated or counterproductive
   - Consolidate redundant instructions

2. **Skills** (`~/.claude/skills/<name>/SKILL.md` or `.claude/skills/<name>/SKILL.md`)
   - Create new skills for recurring workflows discovered during the session
   - Update existing skills that didn't work well
   - Add supporting files (templates, scripts) to existing skills

3. **MCP servers** (in `~/.claude/settings.json` under `mcpServers`)
   - Suggest new MCP servers that would help with common tasks
   - Fix or update existing MCP server configurations

4. **Hooks** (in `~/.claude/settings.json` under `hooks`)
   - Add pre/post tool-use hooks for quality gates
   - Add stop hooks for session-end actions

5. **Settings & permissions** (in `~/.claude/settings.json`)
   - Update permission allow/deny lists based on frequently approved tools
   - Adjust other settings for better workflow

## Process

1. **Diagnose**: Read `~/.claude/CLAUDE.md`, `~/.claude/settings.json`, and scan `~/.claude/skills/` and `~/.claude/commands/` to understand current setup
2. **Identify gaps**: Based on `$ARGUMENTS` or session context, identify what's missing or could be improved
3. **Propose changes**: List specific changes with rationale
4. **Apply**: Make the changes after user confirms (or immediately if clearly beneficial and low-risk like adding a learned convention to CLAUDE.md)
5. **Verify**: Read back modified files to confirm correctness

## Guidelines

- Be surgical: small, targeted improvements over large rewrites
- Preserve existing instructions unless they're wrong
- When adding to CLAUDE.md, append to the appropriate section or create a new section
- When creating skills, use proper frontmatter and keep SKILL.md under 500 lines
- Always explain what was changed and why
