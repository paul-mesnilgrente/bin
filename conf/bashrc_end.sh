# POWERLINE
if [ -f /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh ]; then
    source /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh
elif [ -f /usr/local/lib/python3.5/dist-packages/powerline/bindings/bash/powerline.sh ]; then
    source /usr/local/lib/python3.5/dist-packages/powerline/bindings/bash/powerline.sh
elif [ -f /usr/local/lib/python3.6/dist-packages/powerline/bindings/bash/powerline.sh ]; then
    source /usr/local/lib/python3.6/dist-packages/powerline/bindings/bash/powerline.sh
elif [ -f /home/paul/.pyenv/versions/3.6.5/envs/tools3/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh ]; then
    source /home/paul/.pyenv/versions/3.6.5/envs/tools3/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
fi

source "${HOME}"/bin/tab_title.sh
source "${HOME}"/bin/custom_output.sh
"${HOME}"/bin/welcome_message.sh
