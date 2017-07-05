#!/bin/bash

BASE_PATH=`dirname $0`
MEMOS_PATH=`echo "$BASE_PATH"/assets/memos`

function menu {
    echo "What do you wanna see ?"

    i=1
    for file in `ls $MEMOS_PATH`; do
        echo "    $i". "$file"
        i=`expr $i + 1`
    done

    echo "    q. quit"
    printf "Enter your choice: "
}

function check_answer {
    answer="$1"
    if [ "$answer" = 'q' ]; then
        echo "Goodbye!"
        exit 0
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

function print_memo {
    answer=$1
    file=`ls "$MEMOS_PATH" | head -n "$answer" | tail -n 1`
    cat "$MEMOS_PATH"/"$file"
}

menu
read answer
check_answer "$answer"
print_memo "$answer"

exit 0
