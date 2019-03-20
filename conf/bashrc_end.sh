# POWERLINE
if [ $(uname) = "Linux" ]; then
    if type "powerline" &> /dev/null; then
        usr_prefix='/usr/local/lib'
        usr_suffix='dist-packages/powerline/bindings/bash/powerline.sh'
        if [ -f "$usr_prefix/python3.6/$usr_suffix" ]; then
            source "$usr_prefix/python3.6/$usr_suffix"
        fi
    fi
elif [ $(uname) = "Darwin" ]; then
    source /usr/local/lib/python3.7/site-packages/powerline/bindings/bash/powerline.sh
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
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
fi
if type rbenv &> /dev/null; then
    if [ $(uname) = 'Darwin' ]; then
        eval "$(rbenv init -)"
    fi
fi
# pyenv configuration
if [ -d "${HOME}/.pyenv" ]; then
    export PATH="${HOME}/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
else
    echo "You should install pyenv."
fi

if type vim &> /dev/null; then
    export EDITOR=vim
fi
