#!/bin/bash

# get files
nb_line=`cowsay -l | wc -l`
nb_line=`expr $nb_line - 1`
text=`cowsay -l | tail -n $nb_line`

# pick one random index file
nb_file=`echo $text | wc -w`
# +1 to have the possibility to pick the last file
nb_file=`expr $nb_file + 1`
number=0
while [ "$number" -eq 0 ]; do
    number=$RANDOM
    number=`expr $number % $nb_file`
done

# get the filename and display
filename=`echo $text | cut -d ' ' -f $number`
fortune | cowsay -f $filename | lolcat
