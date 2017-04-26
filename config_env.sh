#!/bin/sh

EXEC_DIR=`dirname "$0"`

sudo apt install -y python-pip tmux curl vim-nox-py2
sudo pip install --upgrade pip
sudo pip install powerline-status

wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/

if [ ! -f "$EXEC_DIR"/powerline-symbols.ttf ]; then
    sudo cp "$EXEC_DIR"/powerline-symbols.ttf /usr/share/fonts/
    sudo fc-cache -vf
else
    # patch found on https://github.com/oconnor663/powerline-fontpacher
    sudo apt install -y fontforge 
    wget https://raw.githubusercontent.com/oconnor663/powerline-fontpatcher/master/fonts/powerline-symbols.sfd
    fontforge -lang ff -c 'Open($1); Generate($2)' powerline-symbols.sfd powerline-symbols.ttf
    sudo mv powerline-symbols.ttf /usr/share/fonts/
fi
sudo fc-cache -vf

ln -s "$EXEC_DIR"/base_vimrc ~/.vimrc
ln -s "$EXEC_DIR"/base_tmux_conf ~/.tmux.conf
ln -s "$EXEC_DIR"/base_tmux_theme ~/.tmux.theme

# POWERLINE
echo '
# POWERLINE
if [ -f /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh ]; then
    source /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh
fi' >> ~/.bashrc

# PATHOGEN
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# COLORSCHEME
git clone https://github.com/flazz/vim-colorschemes ~/.vim/bundle/vim-colorschemes

# VIM-ROS
git clone https://github.com/taketwo/vim-ros ~/.vim/bundle/vim-ros

# C++11 highlighting
git clone https://github.com/octol/vim-cpp-enhanced-highlight.git ~/.vim/bundle/vim-cpp-enhanced-highlight

