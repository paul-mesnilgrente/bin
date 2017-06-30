#!/bin/bash

# get files
nb_line=`cowsay -l | wc -l`
nb_line=`expr $nb_line - 1`
text=`cowsay -l | tail -n $nb_line`

# pick one random index file
nb_file=`echo $text | wc -w`
nb_file=`expr $nb_file + 1`
number=$RANDOM
number=`expr $number + 1`
number=`expr $number % $nb_file`

# get the filename and display
filename=`echo $text | cut -d ' ' -f $number`
echo "filename:" $filename
fortune | cowsay -f $filename | lolcat
