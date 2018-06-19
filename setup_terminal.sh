#!/bin/bash

set -e

echo '
# basic configuration
source $HOME/bin/conf/bashrc_end.sh' >> ~/.bashrc
sudo apt install -y tmux vim git python3-pip
sudo pip3 install -U pip
sudo pip install powerline-status

######################################################
# Install NodeJS                                     #
######################################################
# install NodeJS basics
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt update
sudo apt install nodejs
# configure npm
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
# activate new NPM path
export PATH=~/.npm-global/bin:$PATH
echo '
# NPM configuration
export PATH=$HOME/.npm-global/bin:$PATH' >> ~/.bashrc
# activate new NPM path for every new bash
npm install -g npm

######################################################
# Install pyenv                                      #
######################################################
# install pyenv basics
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
# activate pyenv on every new bash
echo '
# pyenv configuration
export PATH="~/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"' >> .bashrc
# activate pyenv in the script
export PATH="~/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
# install python versions
pyenv install 3.6.5
pyenv install 2.7.15

######################################################
# Install some utils                                 #
######################################################
sudo apt install -y cowsay fortune-mod lolcat htop tree sl
npm install -g joplin

######################################################
# Install powerline                                  #
######################################################
sudo cp ~/bin/assets/10-powerline-symbols.conf /etc/fonts/conf.d/
sudo cp ~/bin/assets/powerline-symbols.ttf /usr/share/fonts/
sudo fc-cache -vf

######################################################
# Configure tmux                                     #
######################################################
[ -f ~/.tmux.conf -o -h ~/.tmux.conf ] && rm ~/.tmux.conf
[ -f ~/.tmux.theme -o -h ~/.tmux.theme ] && rm ~/.tmux.theme
ln -s ~/bin/conf/tmux.conf ~/.tmux.conf
ln -s ~/bin/conf/tmux.theme ~/.tmux.theme

######################################################
# Configure vim                                      #
######################################################
[ -f ~/.vimrc -o -h ~/.vimrc ] && rm ~/.vimrc
ln -s ~/bin/conf/vimrc ~/.vimrc

# PATHOGEN
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# COLORSCHEME
git clone https://github.com/flazz/vim-colorschemes ~/.vim/bundle/vim-colorschemes

# C++11 highlighting
git clone https://github.com/octol/vim-cpp-enhanced-highlight.git ~/.vim/bundle/vim-cpp-enhanced-highlight

# MARDOWN Highlighting and commands
git clone https://github.com/plasticboy/vim-markdown ~/.vim/bundle/vim-markdown
git clone https://github.com/godlygeek/tabular.git ~/.vim/bundle/tabular

# MARDOWN Preview
sudo pip install grip
git clone https://github.com/JamshedVesuna/vim-markdown-preview ~/.vim/bundle/vim-markdown-preview

# SYNTASTIC
sudo pip install flake8
git clone --depth=1 https://github.com/vim-syntastic/syntastic ~/.vim/bundle/syntastic

######################################################
# Configure octave                                   #
######################################################
[ -f ~/.octaverc -o -h ~/.octaverc ] && rm ~/.octaverc
ln -s ~/bin/conf/octaverc ~/.octaverc

######################################################
# Configure bash                                     #
######################################################
[ -f ~/.bash_aliases -o -h ~/.bash_aliases ] && rm ~/.bash_aliases
[ -f ~/.gitconfig -o -h ~/.gitconfig ] && rm ~/.gitconfig
ln -s ~/bin/conf/bash_aliases ~/.bash_aliases
ln -s ~/bin/conf/gitconfig ~/.gitconfig

pyenv deactivate
pyenv global 3.6.5 2.7.15
