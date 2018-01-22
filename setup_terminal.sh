#!/bin/bash

set -e

######################################################
# Install prerequisities                             #
######################################################
sudo apt install -y python3 python3-pip python python-pip tmux curl
sudo pip install --upgrade pip
sudo pip3 install --upgrade pip

######################################################
# Install some utils                                 #
######################################################
sudo apt install -y cowsay fortune-mod lolcat htop
sudo pip install speedtest-cli

######################################################
# Install powerline                                  #
######################################################
sudo pip install powerline-status

wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/

if [ -f ~/bin/assets/powerline-symbols.ttf ]; then
    sudo cp ~/bin/assets/powerline-symbols.ttf /usr/share/fonts/
else
    # patch found on https://github.com/oconnor663/powerline-fontpacher
    sudo apt install -y fontforge 
    wget https://raw.githubusercontent.com/oconnor663/powerline-fontpatcher/master/fonts/powerline-symbols.sfd
    fontforge -lang ff -c 'Open($1); Generate($2)' powerline-symbols.sfd powerline-symbols.ttf
    rm powerline-symbols.sfd
    sudo mv powerline-symbols.ttf /usr/share/fonts/
fi
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

######################################################
# Configure octave                                   #
######################################################
[ -f ~/.octaverc -o -h ~/.octaverc ] && rm ~/.octaverc
ln -s ~/bin/conf/octaverc ~/.octaverc

######################################################
# Configure terminal_velocity                        #
######################################################
[ -f ~/.tvrc -o -h ~/.tvrc ] && rm ~/.tvrc

sudo pip install terminal_velocity
ln -s ~/bin/conf/tvrc ~/.tvrc

######################################################
# Configure bash                                     #
######################################################
[ -f ~/.bash_aliases -o -h ~/.bash_aliases ] && rm ~/.bash_aliases
[ -f ~/.gitconfig -o -h ~/.gitconfig ] && rm ~/.gitconfig
ln -s ~/bin/conf/bash_aliases ~/.bash_aliases
ln -s ~/bin/conf/gitconfig ~/.gitconfig

echo "source ~/bin/conf/bashrc_end.sh" >> ~/.bashrc
