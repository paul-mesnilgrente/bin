"${HOME}/bin/welcome_message.sh"

function source_file()
{
    [ -s "$1" ] && source "$1"
    return $?
}

function add_folder_to_path()
{
    [ -d "$1" ] && \
    echo $PATH | grep "$1" &> /dev/null || \
    export PATH="$1:$PATH"
    return $?
}

# POWERLINE
if type powerline &> /dev/null; then
    if [ $(uname) = "Linux" ]; then
        path="/usr/local/lib/python3.6/dist-packages/powerline/bindings/bash/powerline.sh"
    elif [ $(uname) = "Darwin" ]; then
        path="/usr/local/lib/python3.7/site-packages/powerline/bindings/bash/powerline.sh"
    fi
    source_file "$path"
fi

source_file "${HOME}/bin/tab_title.sh"
source_file "${HOME}/bin/custom_output.sh"
source_file "${HOME}/.bash_aliases"

add_folder_to_path "$HOME/bin"
add_folder_to_path "$HOME/.local/bin"
add_folder_to_path "$HOME/.symfony" || echo 'You should install symfony.'

# nvm configuration
[ -d "${HOME}/.nvm" ] && export NVM_DIR="${HOME}/.nvm" || echo 'You should install nvm.'
source_file "${NVM_DIR}/nvm.sh"
source_file "${NVM_DIR}/bash_completion"

# rbenv configuration
add_folder_to_path "$HOME/.rbenv/bin"
type rbenv &> /dev/null && eval "$(rbenv init -)" || echo 'You should install rbenv.'

# pyenv configuration
if [ -d "${HOME}/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    add_folder_to_path "${PYENV_ROOT}/bin"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
else
    echo "You should install pyenv."
fi

type vim &> /dev/null && export EDITOR=vim || echo 'You should install vim.'
