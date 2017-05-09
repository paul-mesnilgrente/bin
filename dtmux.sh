#!/bin/sh

# if the ros session does not exist yet
tmux switch -t ros 2> /dev/null
if [ $? -ne 0 ]; then
    # rename current session (first name in the status bar)
    tmux rename-session ros

    # create new windows and rename the current one
    tmux rename-window -t 1 mario
    tmux send-keys -t mario 'cd ~/mario/src/mario/src && clear' Enter
    tmux new-window -n compilation -c ~/mario
    tmux new-window -n others -c ~/

    # select the first window
    tmux select-window -t mario
fi
