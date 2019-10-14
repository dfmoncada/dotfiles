#!/bin/sh
setup_sldesk () {
  tmux -2 new-session -d -s sldesk -n API
  tmux send-keys "cd $slapi" C-m "clear" C-m
  tmux new-window -t sldesk -n FE
  tmux send-keys "cd $slfe" C-m "clear" C-m
}

setup_sldesk_servers () {
  tmux -2 new-session -d -s irwin_servers -n servers
  tmux send-keys "cd $slapi" C-m "clear" C-m "rails s" C-m
  tmux split-window -h
  tmux send-keys "cd $slfe" C-m "clear" C-m "npm start" C-m
}

setup_sldesk
setup_sldesk_servers
