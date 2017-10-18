#!/bin/sh

EXEC_DIR=`dirname "$0"`

######################################################
# Install prerequisities                             #
######################################################
sudo apt install -y python-pip tmux curl cowsay fortune-mod lolcat
sudo pip install --upgrade pip

######################################################
# Install powerline                                  #
######################################################
sudo pip install powerline-status

wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/

if [ -f "$EXEC_DIR"/assets/powerline-symbols.ttf ]; then
    sudo cp "$EXEC_DIR"/assets/powerline-symbols.ttf /usr/share/fonts/
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
rm ~/.tmux.conf ~/.tmux.theme &> /dev/null
ln -s "$EXEC_DIR"/conf/tmux.conf ~/.tmux.conf
ln -s "$EXEC_DIR"/conf/tmux.theme ~/.tmux.theme

######################################################
# Configure vim                                      #
######################################################
rm ~/.vimrc &> /dev/null
ln -s "$EXEC_DIR"/conf/vimrc ~/.vimrc

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
rm ~/.octaverc &> /dev/null
ln -s "$EXEC_DIR"/conf/octaverc ~/.octaverc

######################################################
# Configure terminal_velocity                        #
######################################################
rm ~/.tvrc &> /dev/null

sudo pip install terminal_velocity
ln -s "$EXEC_DIR"/conf/tvrc ~/.tvrc

######################################################
# Configure bash                                     #
######################################################
rm ~/.bash_aliases ~/.gitconfig &> /dev/null
ln -s "$EXEC_DIR"/conf/bash_aliases ~/.bash_aliases
ln -s "$EXEC_DIR"/conf/gitconfig ~/.gitconfig

echo "source ${EXEC_DIR}/conf/bashrc_end.sh" >> ~/.bashrc
