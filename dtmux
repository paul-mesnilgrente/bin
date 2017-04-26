#!/bin/sh

# kill all previous sessions
tmux kill-session -a

# rename current session (first name in the status bar)
tmux rename-session ros

# create new windows and rename the current one
tmux rename-window -t '1' mario
tmux new-window -n compilation -c ~/mario
tmux new-window -n others -c ~/

# select the first window
tmux select-window -t 1
