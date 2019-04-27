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
                    htop tree sl curl
sudo pip3 install -U pip

# Install symfony
######################################################
# Install Composer and Symfony                       #
######################################################
# install composer
${HOME}/bin/install_composer.sh
# install symfony
curl -sS https://get.symfony.com/cli/installer | bash
# install autocompletion for composer and symfony tools
export PATH="${HOME}/.local/bin:${PATH}"
composer global require bamarni/symfony-console-autocomplete

######################################################
# Install NVM, NodeJS and NPM                        #
######################################################
# Manual install of nvm 
export NVM_DIR="${HOME}/.nvm"
git clone https://github.com/creationix/nvm.git "$NVM_DIR"
cd "${NVM_DIR}"
git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
source "${NVM_DIR}/nvm.sh"
# install latest lts of node
nvm install --lts
# install/update npm
npm install -g npm

######################################################
# Install jenv                                       #
######################################################
git clone https://github.com/jenv/jenv.git "${HOME}/.jenv"
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
jenv enable-plugin export

######################################################
# Install Joplin                                     #
######################################################
type joplin &> /dev/null && previously_installed=0 || previously_installed=1
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
        tmp=`pwd`
        cd "$HOME/.vim/bundle"
        git clone --depth 1 "$1" "$plugin"
        cd "$tmp"
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
if [ $() = 'Linux' ]; then
    sudo snap install bw
    bw config server 'https://bitwarden.paul-mesnilgrente.com/'
fi

######################################################
# Configure Octave                                   #
######################################################
install_config_file octaverc

######################################################
# Configure Bash                                     #
######################################################
install_config_file bash_aliases
install_config_file gitconfig

######################################################
# Install Pyenv                                      #
######################################################
# install pyenv basics
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev
if [ ! -d "$HOME/.pyenv" ]; then
    echo 'Installing pyenv'
    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    # activate pyenv in the script (already in bashrc_end.sh)
    export PATH="~/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
else
    echo 'Updating pyenv'
    pyenv update && echo 'OK'
fi

######################################################
# Install Phpbrew                                    #
######################################################
if [ $() = 'Darwin' ]; then
    xcode-select --install
    brew install automake autoconf curl pcre bison re2c mhash libtool icu4c gettext jpeg openssl libxml2 mcrypt gmp libevent
    brew link icu4c
    brew link --force openssl
    brew link --force libxml2
else
    sudo apt-get install -y php php-cli
    sudo apt-get install -y build-essential autoconf automake autotools-dev re2c
    sudo apt-get install -y  \
      libxml2 libxml2-dev \
      libssl-dev openssl \
      gettext \
      libicu-dev \
      libmcrypt-dev libmcrypt4 \
      libmhash-dev libmhash2 \
      libfreetype6 libfreetype6-dev \
      libgd-dev libgd3 \
      libpng-dev libpng16-16 \
      libjpeg-dev libjpeg8-dev libjpeg8 \
      libxpm4 libltdl7 libltdl-dev libreadline-dev
fi
curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
chmod +x phpbrew
mv phpbrew "${HOME}/.local/bin"
phpbrew init


# install python versions
pyenv versions | grep '3.6.5'  &> /dev/null && pyenv install 3.6.5
pyenv versions | grep '2.7.15' &> /dev/null && pyenv install 2.7.15
pyenv global 3.6.5 2.7.15
