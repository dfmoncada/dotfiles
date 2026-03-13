# ~/.zshrc — modular, macOS + Linux compatible

# Detect OS
export IS_MACOS=$([[ "$(uname)" == "Darwin" ]] && echo 1 || echo 0)
export IS_LINUX=$([[ "$(uname)" == "Linux" ]] && echo 1 || echo 0)

# Modular config
source $HOME/.zsh/exports
source $HOME/.zsh/path
source $HOME/.zsh/aliases
source $HOME/.zsh/functions
source $HOME/.zsh/plugins
source $HOME/.zsh/prompt

# Oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Completions
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
autoload -U compinit && compinit
autoload -Uz vcs_info
function precmd () { vcs_info }

# Keybindings (emacs mode)
bindkey -e
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

# ZSH options
setopt AUTO_CD
setopt AUTO_PARAM_SLASH
setopt AUTO_PUSHD
setopt AUTO_RESUME
setopt CLOBBER
setopt CORRECT
setopt CORRECT_ALL
setopt NO_FLOW_CONTROL
setopt NO_HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt IGNORE_EOF
setopt INTERACTIVE_COMMENTS
setopt LIST_PACKED
setopt MENU_COMPLETE
setopt NO_NOMATCH
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt SHARE_HISTORY

HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# Edit command line with $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line

# CTRL-Z toggle foreground/background
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg
bindkey '^Z' fg-bg

# Command timer in RPROMPT
typeset -F SECONDS
function -record-start-time() {
  emulate -L zsh
  ZSH_START_TIME=${ZSH_START_TIME:-$SECONDS}
}
add-zsh-hook preexec -record-start-time

function -report-start-time() {
  emulate -L zsh
  if [ $ZSH_START_TIME ]; then
    local DELTA=$(($SECONDS - $ZSH_START_TIME))
    local DAYS=$((~~($DELTA / 86400)))
    local HOURS=$((~~(($DELTA - $DAYS * 86400) / 3600)))
    local MINUTES=$((~~(($DELTA - $DAYS * 86400 - $HOURS * 3600) / 60)))
    local SECS=$(($DELTA - $DAYS * 86400 - $HOURS * 3600 - $MINUTES * 60))
    local ELAPSED=''
    test "$DAYS" != '0' && ELAPSED="${DAYS}d"
    test "$HOURS" != '0' && ELAPSED="${ELAPSED}${HOURS}h"
    test "$MINUTES" != '0' && ELAPSED="${ELAPSED}${MINUTES}m"
    if [ "$ELAPSED" = '' ]; then
      SECS="$(print -f "%.2f" $SECS)s"
    elif [ "$DAYS" != '0' ]; then
      SECS=''
    else
      SECS="$((~~$SECS))s"
    fi
    ELAPSED="${ELAPSED}${SECS}"
    export RPROMPT="%F{cyan}${ELAPSED}%f $RPROMPT_BASE"
    unset ZSH_START_TIME
  else
    export RPROMPT="$RPROMPT_BASE"
  fi
}
add-zsh-hook precmd -report-start-time

# Auto ls after cd
function -auto-ls-after-cd() {
  emulate -L zsh
  if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then
    ls -l
  fi
}
add-zsh-hook chpwd -auto-ls-after-cd

# VCS info for prompt
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green}●%f"
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f"
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*:*' formats '[%b%m%c%u] '
zstyle ':vcs_info:git*:*' actionformats '[%b|%a%m%c%u] '

RPROMPT_BASE="\${vcs_info_msg_0_}%F{blue}%~%f"
setopt PROMPT_SUBST
export RPROMPT=$RPROMPT_BASE
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

# Completion styling
zstyle ':completion:*' list-colors ''
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %F{default}%B--- %d ---%b%f
zstyle ':completion:*' menu select

autoload -U colors
colors

# Source local overrides (not tracked in git)
[[ -f $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

# Docker init (macOS)
[[ -f $HOME/.docker/init-zsh.sh ]] && source $HOME/.docker/init-zsh.sh
