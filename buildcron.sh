#!/bin/bash

function usage {
    echo "Usage:"
    echo "    $0"
    echo "    $0 -h"

    memo
}

function memo {
    echo ''
    echo "######################################"
    echo "#                MEMO                #"
    echo "######################################"
    echo 'Syntax:
 ┌───────────── minute (0 - 59)
 │ ┌───────────── hour (0 - 23)
 │ │ ┌───────────── day of month (1 - 31)
 │ │ │ ┌───────────── month (1 - 12)
 │ │ │ │ ┌───────────── day of week (0 - 6) (Sunday to Saturday;
 │ │ │ │ │                                       7 is also Sunday on some systems)
 │ │ │ │ │
 │ │ │ │ │
 * * * * *  command to execute
'

    echo 'Frequency memo:'
    echo '    "*": every'
    echo '    "*/15": every 15'
    echo '    "0": at each occurence of 0'
    echo '    "0-11": from 0 to 11 included'
    echo '    "1,11": at 1 and 11'
    echo ''
    echo 'Examples:'
    echo '    `* * * * *`: each minute'
    echo '    `*/15 * * * *`: every 15 minutes'
    echo '    `* 0-11 * * *`: each minute before midday'
    echo '    `0 0 1 * * *`: at midnight, on the first day of each month'
    echo ''
}

function valid_syntax {
    input=$1
}

function ask_frequency {
    # m h dom mon dow command
    printf 'Enter the frequency for m (minute): ';         read m
    printf 'Enter the frequency for h (hour): ';           read h
    printf 'Enter the frequency for dom (day of month): '; read dom
    printf 'Enter the frequency for mon (month): ';        read mon
    printf 'Enter the frequency for dow (day of week): ';  read dow
    frequency="$m $h $dom $mon $dow"
}

function ask_command {
    printf 'Enter the command that you want to execute: '; read command
}

function ask_user {
    printf 'Enter the user for which to add the cron: '; read user
}

if [ $# -gt 0 ]; then
    usage; exit 1
fi

memo

frequency=''
command=''
user=''

ask_frequency
ask_command
ask_user

echo ''
echo 'To add this cron, you must execute this command:'
echo "(crontab -l 2>/dev/null; echo '$frequency $command') | crontab -u $user -"

exit 0
