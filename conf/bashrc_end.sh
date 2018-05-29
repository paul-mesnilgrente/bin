# POwERLINE
if [ "$TERM" != "linux" ]; then
    if type "powerline" &> /dev/null; then
        usr_prefix='/usr/local/lib'
        usr_suffix='dist-packages/powerline/bindings/bash/powerline.sh'
        if [ -f "$usr_prefix/python3.6/$usr_suffix" ]; then
            source "$usr_prefix/python3.6/$usr_suffix"
        fi
    fi
fi

source "${HOME}"/bin/tab_title.sh
source "${HOME}"/bin/custom_output.sh
"${HOME}"/bin/welcome_message.sh
