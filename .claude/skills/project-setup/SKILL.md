---
name: project-setup
description: Initialize Claude Code configuration for a new project. Creates .claude/ directory with project-specific CLAUDE.md, agents, and skills.
disable-model-invocation: true
---

Set up Claude Code configuration for the current project.

## Process

1. Analyze the project:
   - Detect language/framework (check package.json, requirements.txt, project.godot, etc.)
   - Detect test runner and build system
   - Check for existing linter/formatter configs
   - Check for existing CI/CD (.github/workflows, .gitlab-ci.yml)

2. Create `.claude/CLAUDE.md` with:
   - Project description (from README or package.json)
   - Tech stack summary
   - Build commands (dev, test, lint, deploy)
   - Key directories and their purpose
   - Coding conventions detected from existing config

3. Create `.claude/settings.json` with:
   - Relevant permission allowlists for the project's tools
   - Any project-specific hooks

4. Optionally create project-specific skills if patterns are detected

## Output

Show what was created and suggest additional customizations.

If $ARGUMENTS contains specific instructions, incorporate them.
