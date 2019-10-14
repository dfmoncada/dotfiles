#!/bin/sh
setup_irwin () {
  tmux -2 new-session -d -s irwin -n API
  tmux send-keys "cd $api" C-m "clear" C-m
  tmux new-window -t irwin -n FE
  tmux send-keys "cd $fe" C-m "clear" C-m
  tmux new-window -t irwin -n ADMIN
  tmux send-keys "cd $admin" C-m "clear" C-m
  tmux new-window -t irwin -n ETL
  tmux send-keys "cd $etl" C-m "clear" C-m
}

setup_irwin_servers () {
  tmux -2 new-session -d -s irwin_servers -n servers
  tmux split-window
  tmux select-pane -t :.+
  tmux send-keys "cd $api" C-m "clear" C-m "DATABASE_URL=$IRWIN_DB_URL rails s" C-m
  tmux split-window -h
  tmux send-keys "cd $etl" C-m "clear" C-m "npm start" C-m
  tmux select-pane -t :.+
  tmux send-keys "cd $admin" C-m "clear" C-m "npm start" C-m
  tmux split-window -h
  tmux send-keys "cd $fe" C-m "clear" C-m "npm start" C-m
}

setup_irwin
setup_irwin_servers
