#!/bin/bash

for package in fortune cowsay lolcat; do
    if ! type ${package} &> /dev/null; then
        echo "Please install ${package} before to run $0"
        exit 1
    fi
done

# get files
files=`cowsay -l | cut -d ':' -f 2`

# pick one random index file
nb_file=`echo $files | wc -w`
let "number = ($RANDOM % $nb_file) + 1"

# get the filename and display
file=`echo $files | cut -d ' ' -f $number`
fortune | cowsay -f $file | lolcat
