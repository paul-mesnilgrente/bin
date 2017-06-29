#!/bin/bash

if [ $# -eq 2 ]; then
    timeout 1.0s rostopic echo /pose > tmp
    if [ ! -s tmp ];then
        echo "topic /pose is not publishing"
        rm tmp
        exit 2
    fi
    chaine=`grep -e 'x: ' -e 'y: ' tmp | head -n 2 | tr -d ' '`
    echo -e "chaine:" $chaine
    x_d=`echo $chaine | cut -d ' ' -f 1 | head -n 1 | cut -d ':' -f 2`
    y_d=`echo $chaine | cut -d ' ' -f 2 | tail -n 1 | cut -d ':' -f 2`
    echo "x:" $x_d
    echo "y:" $y_d
    x_e=$1
    y_e=$2
    rm tmp
elif [ $# -eq 4 ]; then
    x_d=$1
    y_d=$2
    x_e=$3
    y_e=$4
else
    echo "Usage:"
    echo "    $0 x_departure y_departure x_goal y_goal"
    echo "    $0 x_goal y_goal"
    exit 1
fi

printf 'start: %+.3f %+.3f\n' $x_d $y_d
printf 'end:   %+.3f %+.3f\n' $x_e $y_e

rostopic pub -1 /path_input mario/path_input -- '{start: {x: '$x_d', y: '$y_d', theta: 0}, goal: {x: '$x_e', y: '$y_e', theta: 0}}'

exit 0
