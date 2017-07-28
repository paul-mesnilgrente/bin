#!/bin/bash

source ~/bin/custom_output.sh

function usage
{
    echo -e "${Bold}Usage:${Rst}"
    echo -e "    ${Bold}$0${Rst} ${Undr}OPTION${Rst} ${Undr}message${Rst}"
    echo -e "${Bold}OPTION:${Rst}"
    echo -e "    -s, --success"
    echo -e "    -f, --fail"
}

if [ $# -ne 2 ];then
    echo "ERROR: nb_arg != 2."
    usage; exit 1;
fi

opt=$1
message=$2
if [ "$opt" = '-s' -o "$opt" = "--success" ]; then
    style="${Bold}${Green}"
elif [ "$opt" = '-f' -o "$opt" = "--fail" ]; then
    style="${Bold}${Red}"
else
    echo "ERROR: option not recognized."
    usage; exit 2;
fi

nb_car=`printf "$message" | wc -m`
nb_sharp=`expr $nb_car + 4`

printf "${style}"
printf '#%.0s' `seq $nb_sharp`
printf '\n'
printf '# %s #\n' "$message"
printf '#%.0s' `seq $nb_sharp`
printf "${Rst}\n"

exit 0
