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
    answer="$1"
    if [ "$answer" = 'q' ]; then
        goodbye
    elif [ ! "$answer" = 'v' -a ! "$answer" = 'e' -a ! "$answer" = 'c' ]; then
        echo "Your answer must be 'v', 'e', 'c' or 'q'"
        exit 1
    fi
}

function check_answer_number {
    if [ "$answer" = 'q' ]; then
        goodbye
    elif [ ! "$answer" -eq "$answer" ] 2>/dev/null; then
        echo "Your answer must be a positive number or 'q'"
        exit 1
    fi
    nb_file=`ls "$MEMOS_PATH" | wc -l`
    if [ "$answer" -eq 0 -o "$answer" -gt "$nb_file" ]; then
        echo "Your answer must be between 1 and $nb_file".
        exit 2
    fi
}

function check_answer_title {
    if [ "$answer" = 'q' ]; then
        goodbye
    fi
}

function ask_view_memo {
    printf "What memo do you want to view? "
    read answer
    check_answer_number "$answer"
    print_memo "$answer"
}

function ask_edit_memo {
    printf "What memo do you want to edit? "
    read answer
    check_answer_number "$answer"
    edit_memo "$answer"
}

function ask_create_memo {
    printf "What title for the memo? "
    read answer
    check_answer_title "$answer"
    create_memo "$answer"
}

function print_memo {
    answer=$1
    file=`ls "$MEMOS_PATH" | head -n "$answer" | tail -n 1`
    cat "$MEMOS_PATH"/"$file"
}

function edit_memo {
    answer=$1
    file=`ls "$MEMOS_PATH" | head -n "$answer" | tail -n 1`
    vim "$MEMOS_PATH"/"$file"
}

function create_memo {
    answer=$1
    vim "$MEMOS_PATH"/"$answer"
}

menu
read answer
check_answer_action "$answer"
if [ "$answer" = 'v' ]; then
    ask_view_memo
elif [ "$answer" = 'e' ]; then
    ask_edit_memo
    goodbye
elif [ "$answer" = 'c' ]; then
    ask_create_memo
    goodbye
fi

exit 0
