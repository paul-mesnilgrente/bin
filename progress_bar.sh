# Call in a loop to create terminal progress bar
# @params:
# iteration   - Required  : current iteration (Int)
# total       - Required  : total iterations (Int)
# prefix      - Optional  : prefix string (Str)
# suffix      - Optional  : suffix string (Str)
# decimals    - Optional  : positive number of decimals in percent complete (Int)
# length      - Optional  : character length of bar (Int)
# fill        - Optional  : bar fill character (Str)

# To test it : for i in `seq 50`; do progress_bar.sh $i 50 Searching Completed 2 50; sleep 0.1; done
# ATTENTION: if the length is larger than the screen, the progress bar will appear on multiple lines
iteration=$1
total=$2
prefix=$3
suffix=$4
decimals=$5
length=$6
fill='█'

done_length=`echo "$length" '*' "$iteration" '/' "$total" | bc`
sequence_done=`seq $done_length`

todo_length=`expr "$length" '-' "$done_length"`
sequence_todo=`seq $todo_length`

percent=`echo "scale=$decimals;" "$iteration" '*' 100 '/' "$total" | bc`
bar_done=`printf $fill'%.0s' $sequence_done`
if [ $todo_length -eq 0 ]; then
    bar_todo=''
else
    bar_todo=`printf ' %.0s' $sequence_todo`
fi

printf "\r%s |%s%s| %s%% %s\r" "$prefix" "$bar_done" "$bar_todo" "$percent" "$suffix"
# printf "\r%s || %s%% %s\r" "$prefix" "$percent" "$suffix"
# Print New Line on Complete
if [ "$iteration" = "$total" ]; then
    echo ""
fi
