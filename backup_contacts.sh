#!/bin/bash

function usage {
    echo "Usage:"
    echo "    $0 [-f] <credential_path>"
    echo ""
    echo "The file containing the credentials must have this syntax:"
    echo '""""""""""""'
    echo "url"
    echo "username"
    echo "password"
    echo '""""""""""""'
    echo "With an optionnal empty line at the end."
}

force=false
credential=''
url=''
if [ $# -eq 1 ]; then
    credential=$1
elif [ $# -eq 2 ]; then
    if [ $1 != "-f" ]; then
        echo "ERROR: number of parameters = 2 and first parameters != -f"
        usage; exit 2
    fi
    force=true
    credential=$2
else
    echo "ERROR: wrong number of parameters"
    usage; exit 1
fi

if [ ! -f "$credential" ]; then
    echo "ERROR: $credential not a file"
    usage; exit 3
fi

nb_line=`cat "$credential" | wc -l`
if [ $nb_line -gt 4 ]; then
    echo "ERROR: $credential contains more than 4 lines"
    usage; exit 4
fi
if [ $nb_line -lt 3 ]; then
    echo "ERROR: $credential contains less than 3 lines"
    usage; exit 5
fi
url=`head -n 1 "$credential"`
username=`head -n 2 "$credential" | tail -n 1`
password=`tail -n 1 "$credential"`

filepath="/home/$username.vcf"
filepath_save="/home/.$username.vcf"
wget --user "$username" --password "$password" "$url" -O "$filepath"
if [ $? -ne 0 ]; then
    echo ""
    echo "ERROR: failed to retrieve the vcf file."
    echo "HINT: Verify your credentials and the url."
    echo "$username"
    echo "$password"
    echo "$url"
    echo ""
    usage
    sendmail.php "Paul Mesnilgrente <web@paul-mesnilgrente.com>" \
                 "[ERROR]Contacts Backup $username" \
                 "ERROR while exporting contacts for user \"$username\"."
    exit 2
fi

if [ "$force" = "false" ]; then
    if [ -f "$filepath_save" ]; then
        diff "$filepath" "$filepath_save"
        if [ $? -eq 0 ]; then
            sendmail.php "Paul Mesnilgrente <web@paul-mesnilgrente.com>" \
                 "[$username]Contacts Backup -> up to date" \
                 "Already up to date."
            mv "$filepath" "$filepath_save"
            log.py "Email sent, files up-to-date"
            exit 0
        else
            log.py -l ERROR "diff return a difference"
        fi
    else
        log.py -l ERROR "filepath_save does not exist"
    fi
fi

sendmail.php "Paul Mesnilgrente <web@paul-mesnilgrente.com>" \
             "[$username]Contacts Backup -> changed" \
             "backup" \
             "$filepath"
log.py "forced, email sent"
mv "$filepath" "$filepath_save"

exit 0
