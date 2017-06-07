#!/bin/bash

BASE_PATH=`dirname $0`
while [ 0 ]; do
    echo "What do you wanna see ?"
    echo "    1. regex"
    echo "    2. vim"
    echo "    3. ros"
    echo "    4. latex"
    echo "    q. quit"

    printf "Enter your choice: "
    read answer
    if [ "$answer" = '1' ]; then
        cat $BASE_PATH/assets/memos/regex.md
        exit 0
    elif [ "$answer" = '2' ]; then
        cat $BASE_PATH/assets/memos/vim.md
        exit 0
    elif [ "$answer" = '3' ]; then
        cat $BASE_PATH/assets/memos/regex.md
        exit 0
    elif [ "$answer" = '4' ]; then
        cat $BASE_PATH/assets/memos/latex.md
        exit 0
    elif [ "$answer" = 'q' ]; then
        echo "Goodbye!"
        exit 0
    else
        echo "Invalid input."
    fi
done
