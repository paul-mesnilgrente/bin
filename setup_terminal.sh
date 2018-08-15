#!/bin/bash

set -e

function install_config_file {
    filename="${1}"
    rm -f "${HOME}/.${filename}"
    ln -s "${HOME}/bin/conf/${filename}" "${HOME}/.${filename}"
}

if ! grep bashrc_end "$HOME/.bashrc" > /dev/null; then
    echo '
# basic configuration
source "$HOME/bin/conf/bashrc_end.sh"' >> ~/.bashrc
fi
sudo apt install -y tmux vim git python3-pip xclip \
                    cowsay cowsay-off fortune-mod lolcat \
                    htop tree sl
sudo pip3 install -U pip

######################################################
# Install NodeJS                                     #
######################################################
# install NodeJS basics
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt update
sudo apt install nodejs
# configure npm
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
# activate new NPM path (already configured in bashrc_end.sh)
export PATH=~/.npm-global/bin:$PATH
# update npm
npm install -g npm

######################################################
# Install Pyenv                                      #
######################################################
# install pyenv basics
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev
if [ ! "$HOME/.pyenv" ]; then
    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    # activate pyenv in the script (already in bashrc_end.sh)
    export PATH="~/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
else
    pyenv update
fi

# install python versions
pyenv versions | grep 3.6.5 > /dev/null
if [ $? -ne 0 ]; then pyenv install 3.6.5; fi
pyenv versions | grep 2.7.15 > /dev/null
if [ $? -ne 0 ]; then pyenv install 2.7.15; fi
# set global system for system-wise tools installation
pyenv global system

######################################################
# Install Joplin                                     #
######################################################
npm list -g joplin | grep joplin > /dev/null
previously_installed="${?}"
npm install -g joplin
if [ ! ${previously_installed} ]; then
    joplin config sync.target 5
    joplin config sync.5.path
    joplin config sync.5.path 'https://nextcloud.paul-mesnilgrente.com/remote.php/webdav/NOTES'
    joplin config sync.5.username 'Paul Mesnilgrente'
    printf 'Please enter your nextcloud password to access Joplin notes:'
    read password
    joplin config sync.5.password "${password}"
fi
joplin sync

######################################################
# Install Powerline                                  #
######################################################
sudo pip install powerline-status
if [ ! -e /etc/fonts/conf.d/10-powerline-symbols.conf ]; then
    sudo cp ~/bin/assets/10-powerline-symbols.conf /etc/fonts/conf.d/
    sudo cp ~/bin/assets/powerline-symbols.ttf /usr/share/fonts/
    sudo fc-cache -vf
fi

######################################################
# Configure Tmux                                     #
######################################################
install_config_file tmux.conf
install_config_file tmux.theme

######################################################
# Configure Vim                                      #
######################################################
install_config_file vimrc

# PATHOGEN
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

function install_vim_plugin {
    plugin=`echo $1 | cut -d '/' -f 5`
    if [ -d "$HOME/.vim/bundle/$plugin" ]; then
        tmp=`pwd`
        cd "$HOME/.vim/bundle/$plugin"
        git pull
        cd "$tmp"
    else
        git clone --depth 1 "$1" "$plugin"
    fi
}

# COLORSCHEME
install_vim_plugin https://github.com/flazz/vim-colorschemes

# C++11 highlighting
install_vim_plugin https://github.com/octol/vim-cpp-enhanced-highlight

# MARDOWN Highlighting and commands
install_vim_plugin https://github.com/plasticboy/vim-markdown
install_vim_plugin https://github.com/godlygeek/tabular

# MARDOWN Preview
sudo pip install grip
install_vim_plugin https://github.com/JamshedVesuna/vim-markdown-preview

# SYNTASTIC
sudo pip install flake8
install_vim_plugin https://github.com/vim-syntastic/syntastic

# CtrlP
install_vim_plugin https://github.com/kien/ctrlp.vim

######################################################
# Configure Bitwarden                                #
######################################################
sudo snap install bw
bw config server 'https://bitwarden.paul-mesnilgrente.com/'

######################################################
# Configure Octave                                   #
######################################################
install_config_file octaverc

######################################################
# Configure Bash                                     #
######################################################
install_config_file bash_aliases
install_config_file gitconfig

pyenv global 3.6.5 2.7.15
