# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"
autoload -Uz vcs_info

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

source $HOME/.zsh/path
source $HOME/.zsh/exports
source $HOME/.zsh/aliases
source $HOME/.zsh/functions
source $HOME/.zsh/prompt

eval "$(rbenv init -)"

# oh-my-sh
source $HOME/.zsh/plugins
source $ZSH/oh-my-zsh.sh

# LOAD powerline fonts
powerline-daemon -q
. /usr/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh
# new line
