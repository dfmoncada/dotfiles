# Dotfiles

Personal dev environment. macOS + Linux compatible.

## Quick Start

```bash
git clone https://github.com/dfmoncada/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

## What's Included

### Shell (zsh)
- Modular `.zshrc` with separate files for aliases, exports, path, functions, plugins
- Cross-platform clipboard, paths, and tools
- Oh My Zsh with minimal plugin set
- Command timer in RPROMPT, git status, auto-ls on cd

### Tmux
- `C-Space` prefix
- Alt+hjkl pane navigation, Alt+Shift for resize
- Cross-platform clipboard (pbcopy/xclip)
- Tmuxinator layout for EZTask

### Git
- Useful aliases (oneline, graph, deploy, fixup, etc.)
- Histogram diff, diff3 merge conflicts, auto-rebase

### Neovim
- Lua config with Telescope, TreeSitter, LSP, completion
- Gruvbox theme, 2-space indent

### Claude Code
- 10 agents: coordinator, architect, production-code-developer, incremental-developer, code-quality-auditor, code-reviewer, debugger, test-runner, data-scientist, devops
- 9 skills: commit, pr, notify, review-pr, sprint-status, fix-issue, project-setup, self-improve, eztask-dev
- 5 commands: rtfm, status, sprint, sync-agents, health
- 4 hooks: activity-log, block-destructive, notify-sound, session-context
- MCP servers: Jira, GitHub, Playwright, Memory, Telegram

### OpenCode
- Same 10 agents (OpenCode frontmatter format)
- Shares skills from `~/.claude/skills/`

## Secrets

Tokens/keys go in `~/.zshrc.local` (not tracked):

```bash
export JIRA_API_TOKEN=...
export GITHUB_TOKEN=...
export TELEGRAM_BOT_TOKEN=...
export TELEGRAM_CHAT_ID=...
```

## Structure

```
.claude/          Claude Code config (agents, skills, hooks, commands)
.config/opencode/ OpenCode config (agents)
.config/tmuxinator/ Tmuxinator layouts
.zsh/             Modular zsh config
nvim/             Neovim lua config
setup.sh          Install script (macOS + Linux)
```
