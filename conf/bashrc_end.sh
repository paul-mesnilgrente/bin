# POWERLINE
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

# use user global npm instead of the system one
echo $PATH | grep '.npm-global' > /dev/null
if [ $? -ne 0 ]; then
    export PATH="$HOME/.npm-global/bin:$PATH"
fi

# use user global npm instead of the system one
if [ -d "${HOME}/.rbenv/bin" ]; then
    echo $PATH | grep '.rbenv' > /dev/null
    if [ $? -ne 0 ]; then
        export PATH="$HOME/.rbenv/bin:$PATH"
    fi
    eval "$(rbenv init -)"
else
    echo "You should install rbenv."
fi

# pyenv configuration
if [ -d "${HOME}/.pyenv/bin" ]; then
    export PATH="${HOME}/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
else
    echo "You should install pyenv."
fi
