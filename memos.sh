#!/bin/bash

BASE_PATH=`dirname $0`
MEMOS_PATH=`echo "$BASE_PATH"/assets/memos`

function goodbye {
    echo "Goodbye!"
    exit 0
}

function menu {
    echo "What do you wanna see ?"

    i=1
    for file in `ls $MEMOS_PATH`; do
        echo "    $i". "$file"
        i=`expr $i + 1`
    done

    echo "    q. quit"
    printf "Enter your choice (v/e/c): "
}

function check_answer_action {
    if [ "$action" = 'q' ]; then
        goodbye
    elif [ ! "$action" = 'v' -a ! "$action" = 'e' -a ! "$action" = 'c' ]; then
        echo "Your answer must contain 'v', 'e', 'c' or 'q'"
        exit 1
    fi
}

function check_answer_number {
    number=$1
    if [ "$number" = 'q' ]; then
        goodbye
    elif [ ! "$number" -eq "$number" ] 2>/dev/null; then
        echo "Your answer must be a positive number or 'q'"
        exit 1
    fi
    nb_file=`ls "$MEMOS_PATH" | wc -l`
    if [ "$number" -eq 0 -o "$number" -gt "$nb_file" ]; then
        echo "The number must be between 1 and $nb_file".
        exit 2
    fi
}

function check_answer_title {
    if [ "$1" = 'q' ]; then
        goodbye
    fi
}

function ask_view_memo {
    if [ $# -eq 0 ]; then
        printf "What memo do you want to view? "
        read number
    else
        number=$1
    fi
    check_answer_number "$number"
    print_memo "$number"
}

function ask_edit_memo {
    if [ $# -eq 0 ]; then
        printf "What memo do you want to edit? "
        read number
    else
        number=$1
    fi
    check_answer_number "$number"
    edit_memo "$number"
}

function ask_create_memo {
    if [ $# -eq 0 ]; then
        printf "What title for the memo? "
        read filename
    else
        filename=$1
    fi
    check_answer_title "$filename"
    create_memo "$filename"
}

function print_memo {
    number=$1
    file=`ls "$MEMOS_PATH" | head -n "$number" | tail -n 1`
    cat "$MEMOS_PATH"/"$file"
}

function edit_memo {
    number=$1
    file=`ls "$MEMOS_PATH" | head -n "$number" | tail -n 1`
    vim "$MEMOS_PATH"/"$file"
}

function create_memo {
    filename=$1
    vim "$MEMOS_PATH"/"$filename"
}

menu
read answer
action=`echo "$answer" | cut -d ' ' -f 1 | sed 's/[0-9]//g'`
opt_number=`echo "$answer" | cut -d ' ' -f 1 | sed 's/[a-Z]//g'`
check_answer_action "$action"

if [ "$action" = 'v' ]; then
    ask_view_memo $opt_number
elif [ "$action" = 'e' ]; then
    ask_edit_memo $opt_number
    goodbye $opt_number
elif [ "$action" = 'c' ]; then
    opt_filename=`echo "$answer" | cut -s -d ' ' -f 2`
    ask_create_memo $opt_filename
    goodbye
fi

exit 0
