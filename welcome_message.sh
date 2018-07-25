#!/bin/bash

for package in cowsay fortune-mod; do
    dpkg -s ${package} &> /dev/null
    if [ $? -ne 0 ]; then
        echo "Please install ${package} before to run $0"
        exit 1
    fi
done
echo "test" | lolcat &> /tmp/lolcat_error
if [ $? -ne 0 ]; then
    echo "Please install lolcat before to run $0"
    echo "ERROR:"
    cat /tmp/lolcat_error
    exit 2
fi

# get files
files=`cowsay -l | cut -d ':' -f 2`

# pick one random index file
nb_file=`echo $files | wc -w`
let "number = ($RANDOM % $nb_file) + 1"

# get the filename and display
file=`echo $files | cut -d ' ' -f $number`
fortune | cowsay -f $file | lolcat
