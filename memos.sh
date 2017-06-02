#!/bin/bash

BASE_PATH=`dirname $0`
while [ 0 ]; do
    echo "What do you wanna see ?"
    echo "    1. regexp"
    echo "    q. quit"

    printf "Enter your choice: "
    read answer
    if [ "$answer" = '1' ]; then
        cat $BASE_PATH/assets/regexp.md
        exit 0
    elif [ "$answer" = 'q' ]; then
        echo "Goodbye!"
        exit 0
    else
        echo "Invalid input."
    fi
done
