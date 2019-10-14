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

source $HOME/.zsh/colors
source $HOME/.zsh/exports
source $HOME/.zsh/path
source $HOME/.zsh/aliases
source $HOME/.zsh/functions

# oh-my-sh
source $ZSH/oh-my-zsh.sh
source $HOME/.zsh/plugins

# LOAD powerline fonts
powerline-daemon -q
. /usr/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh
# new line
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)
