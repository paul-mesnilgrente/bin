function tab_title {
    if [ -z "$1" ]
    then
        title=${PWD##*/} # current directory
    else
        title=$1 # first param
    fi
    echo -n -e "\033]0;$title\007"
}
