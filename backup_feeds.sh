#!/bin/bash

function usage {
    echo "Usage:"
    echo "    $0 [-f] [<username>]"
    echo "    $0 [<username>] [-f]"
}

if [ $# -gt 2 ]; then
    usage; exit 1;
fi

force=false
username="FreshRSS"
if [ $# -ge 1 ]; then
    if [ "$1" = "-f" ]; then
        force=true
    else
        username="$1"
    fi
fi
if [ $# -ge 2 ]; then
    if [ "$2" = "-f" ]; then
        force=true
    else
        username="$2"
    fi
fi

filepath="/home/freshrss.opml.xml"
filepath_save="/home/.freshrss.opml.xml"
filepath_tmp1="/home/freshrss.opml.xml.tmp1"
filepath_tmp2="/home/freshrss.opml.xml.tmp2"
/var/www/FreshRSS/cli/export-opml-for-user.php --user "$username" > "$filepath" 2> /dev/null
if [ $? -ne 0 ]; then
    echo "ERROR: failed to export the opml file."
    echo "HINT: Verify the username (username: $username)."
    usage
    sendmail.php "Paul Mesnilgrente <web@paul-mesnilgrente.com>" \
                 "[ERROR]FreshRSS Backup for $username" \
                 "ERROR while exporting OPML for user \"$username\"."
    exit 2
fi

if [ "$force" = "false" ]; then
    if [ -f "$filepath_save" ]; then
        grep -v '<dateCreated>' "$filepath" > "$filepath_tmp1"
        grep -v '<dateCreated>' "$filepath_save" > "$filepath_tmp2"
        diff "$filepath_tmp1" "$filepath_tmp2" > /dev/null
        if [ $? -eq 0 ]; then
            sendmail.php "Paul Mesnilgrente <web@paul-mesnilgrente.com>" \
                 "[$username]FreshRSS Backup -> up to date" \
                 "Already up to date."
            mv "$filepath" "$filepath_save"
            rm "$filepath_tmp1" "$filepath_tmp2" 2> /dev/null
            exit 0
        fi
    fi
fi

sendmail.php "Paul Mesnilgrente <web@paul-mesnilgrente.com>" \
             "[$username]FreshRSS Backup -> changed" \
             "backup" \
             "$filepath"

mv "$filepath" "$filepath_save"
rm "$filepath_tmp1" "$filepath_tmp2" 2> /dev/null

exit 0
