#!/bin/bash

p_exe="$0"
function usage {
    echo "Usage:"
    echo "    $p_exe <session_name> <src_folder> <build_folder> <script_folder> <others_folder>"
    echo "    $p_exe <session_name>"
}

if [ $# -ne 5 -a $# -ne 1 ]; then
    echo "ERROR: number of arguments mismatch"
    usage; exit 1;
fi

session="$1"
if [ $# -eq 1 ]; then
    # if the ros session does not exist yet
    tmux switch -t "$session" 2> /dev/null
    if [ $? -ne 0 ]; then
        echo "ERROR: $session does not exist"
        usage; exit 2
    fi
    exit 0
fi

shift
for arg in "$@"; do
    if [ ! -d "$arg" ]; then
        echo "ERROR: $arg is not a folder"
        usage exit 2
    fi
done

base_path="`pwd`"
src_folder="$base_path/$1"
build_folder="$base_path/$2"
scripts_folder="$base_path/$3"
others_folder="$base_path/$4"

# rename current session (first name in the status bar)
tmux rename-session "$session"

# create new windows and rename the current one
tmux rename-window -t 1 src
tmux send-keys -t src "cd $src_folder && clear" Enter
tmux new-window -n build -c "$build_folder"
tmux new-window -n scripts -c "$scripts_folder"
tmux new-window -n others -c "$others_folder"

# select the first window
tmux select-window -t src
