# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

export api="$HOME/platform/irwin-app/irwin-api"
export fe="$HOME/platform/irwin-app/irwin-fe"
export etl="$HOME/platform/irwin-app/factset-etl"
export utils="$HOME/platform/node-modules/formatter"
export admin="$HOME/platform/admin-fe"
export org="$HOME/Projects/organizer"
export orgcomp="$HOME/platform/factset/organization_component"
export holdcomp="$HOME/platform/factset/holding_component"
export complib="$HOME/platform/node-modules/component-library"
export deusfe="$HOME/Projects/deuster/react-fe"
export deusapi="$HOME/Projects/deuster/rails-api"
export slapi="$HOME/sldesk/backend"
export slfe="$HOME/sldesk/frontend"

source $HOME/.zsh/exports
source $HOME/.zsh/path
source $HOME/.zsh/aliases
source $HOME/.zsh/functions
source $HOME/.zsh/plugins

eval "$(rbenv init -)"

# oh-my-sh


source $HOME/.dockerrc
source $ZSH/oh-my-zsh.sh
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
autoload -U compinit && compinit
function precmd () { vcs_info }

bindkey -e # emacs bindings, set to -v for vi bindings

# AUTOMCOMPLETE
# source ~/code/personal/scripts/*completion.bash

zstyle ':completion:*' list-colors ''
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %F{default}%B%{$__WINCENT[ITALIC_ON]%}--- %d ---%{$__WINCENT[ITALIC_OFF]%}%b%f
zstyle ':completion:*' menu select

autoload -U colors
colors

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' disable-patterns "${(b)HOME}/code/(commerce|portal|portal-ee|portal-master)(|/*)"
zstyle ':vcs_info:*' stagedstr "%F{green}●%f" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f" # default 'U'
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*:*' formats '[%b%m%c%u] ' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:git*:*' actionformats '[%b|%a%m%c%u] ' # default ' (%s)-[%b|%a]%c%u-'
zstyle ':vcs_info:hg*:*' formats '[%m%b] '
zstyle ':vcs_info:hg*:*' actionformats '[%b|%a%m] '
zstyle ':vcs_info:hg*:*' branchformat '%b'
zstyle ':vcs_info:hg*:*' get-bookmarks true
zstyle ':vcs_info:hg*:*' get-revision true
zstyle ':vcs_info:hg*:*' get-mq false
zstyle ':vcs_info:hg*+gen-hg-bookmark-string:*' hooks hg-bookmarks
zstyle ':vcs_info:hg*+set-message:*' hooks hg-message

RPROMPT_BASE="\${vcs_info_msg_0_}%F{blue}%~%f"
setopt PROMPT_SUBST

export RPROMPT=$RPROMPT_BASE
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

setopt AUTO_CD                 # [default] .. is shortcut for cd .. (etc)
setopt AUTO_PARAM_SLASH        # tab completing directory appends a slash
setopt AUTO_PUSHD              # [default] cd automatically pushes old dir onto dir stack
setopt AUTO_RESUME             # allow simple commands to resume backgrounded jobs
setopt CLOBBER                 # allow clobbering with >, no need to use >!
setopt CORRECT                 # [default] command auto-correction
setopt CORRECT_ALL             # [default] argument auto-correction
setopt NO_FLOW_CONTROL         # disable start (C-s) and stop (C-q) characters
setopt NO_HIST_IGNORE_ALL_DUPS # don't filter non-contiguous duplicates from history
setopt HIST_FIND_NO_DUPS       # don't show dupes when searching
setopt HIST_IGNORE_DUPS        # do filter contiguous duplicates from history
setopt HIST_IGNORE_SPACE       # [default] don't record commands starting with a space
setopt HIST_VERIFY             # confirm history expansion (!$, !!, !foo)
setopt IGNORE_EOF              # [default] prevent accidental C-d from exiting shell
setopt INTERACTIVE_COMMENTS    # [default] allow comments, even in interactive shells
setopt LIST_PACKED             # make completion lists more densely packed
setopt MENU_COMPLETE           # auto-insert first possible ambiguous completion
setopt NO_NOMATCH              # [default] unmatched patterns are left unchanged
# setopt PRINT_EXIT_VALUE        # [default] for non-zero exit status
setopt PUSHD_IGNORE_DUPS       # don't push multiple copies of same dir onto stack
setopt PUSHD_SILENT            # [default] don't print dir stack after pushing/popping
setopt SHARE_HISTORY           # share history across shells

HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line

# Make CTRL-Z background things and unbackground them.
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg
bindkey '^Z' fg-bg

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
    export RPROMPT="%F{cyan}%{$__WINCENT[ITALIC_ON]%}${ELAPSED}%{$__WINCENT[ITALIC_OFF]%}%f $RPROMPT_BASE"
    unset ZSH_START_TIME
  else
    export RPROMPT="$RPROMPT_BASE"
  fi
}
add-zsh-hook precmd -report-start-time

function -auto-ls-after-cd() {
  emulate -L zsh
  # Only in response to a user-initiated `cd`, not indirectly (eg. via another
  # function).
  if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then
    ls -l
  fi
}
add-zsh-hook chpwd -auto-ls-after-cd

setopt no_aliases
source $HOME/.nvm/nvm.sh
setopt aliases

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

export PATH=/Users/diegos/.meteor:$PATH

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true
