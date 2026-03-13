#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname)"

echo "=== Dotfiles setup ($OS) ==="
echo "Source: $DOTFILES"
echo ""

# --- Helpers ---

link() {
  local src="$DOTFILES/$1"
  local dst="$HOME/$1"
  local dir=$(dirname "$dst")

  mkdir -p "$dir"

  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    echo "  backup: $dst -> $dst.backup"
    mv "$dst" "$dst.backup"
  fi

  ln -sf "$src" "$dst"
  echo "  linked: $1"
}

# --- Shell ---
echo ">> Shell configs"
link .zshrc
link .zsh/aliases
link .zsh/exports
link .zsh/functions
link .zsh/path
link .zsh/plugins
link .zsh/prompt

# --- Git ---
echo ">> Git"
link .gitconfig
# .gitignore is the repo's, user gitignore goes to .gitignore_global
ln -sf "$DOTFILES/.gitignore" "$HOME/.gitignore_global"
echo "  linked: .gitignore -> .gitignore_global"

# --- Tmux ---
echo ">> Tmux"
link .tmux.conf

# --- Tmuxinator ---
echo ">> Tmuxinator"
link .config/tmuxinator/eztask.yml

# --- Claude Code ---
echo ">> Claude Code"
link .claude/CLAUDE.md
link .claude/settings.json
for f in "$DOTFILES"/.claude/agents/*.md; do
  link ".claude/agents/$(basename "$f")"
done
for d in "$DOTFILES"/.claude/skills/*/; do
  skill=$(basename "$d")
  link ".claude/skills/$skill/SKILL.md"
done
for f in "$DOTFILES"/.claude/hooks/*.sh; do
  link ".claude/hooks/$(basename "$f")"
  chmod +x "$HOME/.claude/hooks/$(basename "$f")"
done
for f in "$DOTFILES"/.claude/commands/*.md; do
  link ".claude/commands/$(basename "$f")"
done

# --- OpenCode ---
echo ">> OpenCode"
link .config/opencode/opencode.json
for f in "$DOTFILES"/.config/opencode/agent/*.md; do
  link ".config/opencode/agent/$(basename "$f")"
done

# --- Nvim (copy, not link — it's complex) ---
echo ">> Nvim"
if [ -d "$DOTFILES/nvim" ]; then
  mkdir -p "$HOME/.config/nvim"
  if [ -L "$HOME/.config/nvim" ] || [ ! -d "$HOME/.config/nvim/lua" ]; then
    rm -rf "$HOME/.config/nvim"
    ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
    echo "  linked: nvim -> .config/nvim"
  else
    echo "  skipped: .config/nvim already exists (not a symlink)"
  fi
fi

# --- Oh My Zsh ---
echo ">> Oh My Zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "  Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
else
  echo "  already installed"
fi

# --- Platform-specific ---
echo ">> Platform-specific"
if [ "$OS" = "Darwin" ]; then
  echo "  macOS detected"
  # Ensure Homebrew
  if ! command -v brew &>/dev/null; then
    echo "  Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  # Key tools
  brew install --quiet ripgrep fzf jq tmux tmuxinator gh node 2>/dev/null || true

elif [ "$OS" = "Linux" ]; then
  echo "  Linux detected"
  if command -v apt-get &>/dev/null; then
    sudo apt-get update -qq
    sudo apt-get install -y -qq ripgrep fzf jq tmux xclip nodejs npm 2>/dev/null || true
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm --needed ripgrep fzf jq tmux xclip nodejs npm 2>/dev/null || true
  fi
  # gh CLI
  if ! command -v gh &>/dev/null; then
    echo "  Install GitHub CLI: https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
  fi
  # tmuxinator via gem
  if ! command -v tmuxinator &>/dev/null; then
    gem install tmuxinator 2>/dev/null || pip install tmuxinator 2>/dev/null || echo "  Install tmuxinator manually"
  fi
fi

# --- Obsidian vault dirs (for Claude hooks) ---
echo ">> Obsidian vault dirs"
mkdir -p "$HOME/Documents/Obsidian Vault/Claude Code"
mkdir -p "$HOME/Documents/Obsidian Vault/DailyNotes"
touch "$HOME/Documents/Obsidian Vault/Claude Code/Activity Log.md"
touch "$HOME/Documents/Obsidian Vault/Claude Code/Decisions.md"
touch "$HOME/Documents/Obsidian Vault/Claude Code/Plan.md"

# --- Reminder ---
echo ""
echo "=== Done ==="
echo ""
echo "Next steps:"
echo "  1. Set env vars in ~/.zshrc.local (not tracked):"
echo "     export JIRA_API_TOKEN=..."
echo "     export GITHUB_TOKEN=..."
echo "     export TELEGRAM_BOT_TOKEN=..."
echo "     export TELEGRAM_CHAT_ID=..."
echo "  2. Install Claude Code: npm install -g @anthropic-ai/claude-code"
echo "  3. Install OpenCode: https://opencode.ai"
echo "  4. Restart your shell: exec zsh"
