#!/bin/sh

echo 'Système :
    - Installer les langues
    - modifier arrière plan
    - ajouter les espaces de travail
    - installer les logiciels propriétaires
    - lanceur à 36 points
    - veille à jamais
Press enter to continue...'
read y

echo 'Mozilla thunderbird :
    - Enregistrer les comptes thunderbird
    - Installer les extensions :
        - Lightning, 
        - Enigmail,
        - SoGo connector (Front End),
    - Mettre orthographe de correction en francais.
Press enter to continue...'
read y

echo 'Mozilla firefox :
    - aller sur https://startpage.com/ mettre langage à français et thème à blanc,
    - ajouter starpage comme moteur de recherche par défaut,
    - enlever les autres moteurs de recherche,
    - le plugin lastpass,
    - supprimer bookmarks,
    - synchro firefox,
    - configurer wallabag,
    - personnaliser la barre de firefox,
    - ajouter barre personnelle à la vue,
    - Préférences/Sécurité/Décocher "Se souvenir des logins"
    - ajouter le défilement automatique (clic du milieu).

Press enter to continue...'
read y

echo 'Sublime text :
    - installer sublime text,
    - installer le package control,
    - installer markdown preview, LESS.
Press enter to continue...'
read y

echo '
###########################
# Suppression des paquets #
###########################
'

sudo apt autoremove --purge -y unity-webapps-common totem shotwell shotwell-common


echo '
######################################
# Ajout de la version oracle de java #
######################################
'

sudo add-apt-repository -y ppa:webupd8team/java

echo '
############################
# Ajout du ppa de owncloud #
############################
'
# pour ubuntu 16.04
wget -nv http://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_16.04/Release.key -O Release.key
sudo apt-key add - < Release.key
rm Release.key
sudo apt update

sudo sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_16.04/ /' > /etc/apt/sources.list.d/owncloud-client.list"

echo '
#############################
# Ajout du ppa de darktable #
#############################
'
sudo add-apt-repository -y ppa:pmjdebruijn/darktable-release

echo '
######################################
# Mise à jour des logiciels          #
######################################
'
sudo apt -y update
sudo apt -y upgrade

echo '
######################################
# Installation des logiciels         #
######################################
'

# la base
liste=\
"nautilus-dropbox \
easytag \
vim tree \
ttf-mscorefonts-installer \
vlc \
gimp \
xournal \
gnome-chess \
grisbi \
gparted \
libreoffice-java-common \
oracle-java8-installer \
git \
owncloud-client owncloud-client-nautilus \
curl libgnome2-bin \
darktable python-pygments"

sudo apt install -y $liste

echo '
######################################
# Installation des logiciels OK      #
######################################
'

echo 'Installer language tools. Press enter to continue...'
read y

echo "Lanceur :
    - Fichiers
    - Firefox
    - Thunderbird
    - Rhythmbox
    - Visionneur de Documents
    - Grisbi
    - Sublime_text
    - Terminal
    - Paramètres
    - Bureaux
Press enter to continue..."
read y

echo "Clefs SSH :
    - Enter the path to the folder that contains your keys:"
read pathToSSHKeys
mkdir ~/.ssh
cp "$pathToSSHKeys"/id_rsa* ~/.ssh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
ssh-add

rm -rf examples.desktop Modèles Public
echo '
# function to set terminal title
function set-title(){
  if [[ -z "$ORIG" ]]; then
    ORIG=$PS1
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1=${ORIG}${TITLE}
}
' >> ~/.bashrc

echo "# package manager
alias install='sudo apt install'
alias update='sudo apt update'
alias upgrade='sudo apt update && sudo apt upgrade'
alias show='apt-cache show'
alias search='apt-cache search'
alias autoremove='sudo apt autoremove --purge'

# symfony
alias sy='php bin/console'
alias sy_dbupdate='sy doctrine:schema:update'
alias sy_ge='sy doctrine:generate:entity'
alias sy_gf='sy doctrine:generate:form'
alias sy_ges='sy doctrine:generate:entities'
alias sy_clearp='sy cache:clear --env=prod'
alias sy_cleard='sy cache:clear --env=dev'

# divers
alias gdb='gdb -q'
alias go='gnome-open'
alias taille='du -hs'
alias ccat='pygmentize -g'" >> ~/.bash_aliases

echo "[color]
    diff = auto
    status = auto
    branch = auto
[user]
    name = Paul Mesnilgrente
    email = web@paul-mesnilgrente.com
[alias]
    ci = commit
    co = checkout
    st = status --short
    br = branch
    lg = log --graph --pretty=format:'%C(red)%h%Creset - %s %C(green)(%cr) %C(bold blue)<%an>%Creset%C(yellow)%d%Creset' --abbrev-commit
[push]
    default = simple" >> ~/.gitconfig

echo 'Installation de vim et configuration...'


echo 'syntax on
set background=dark
set number
set showcmd
set mouse=a
set hidden
set autowrite
set showmatch
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with >, use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab' > ~/.vimrc

echo '{
    "ensure_newline_at_eof_on_save": true,
    "word_wrap": false,
}' > "$HOME/.config/sublime-text-3/Packages/User/Preferences.sublime-settings"

echo "fs.inotify.max_user_watches = 524288" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

echo '
####################################################
# Installation de la suite apache, symfony etc.    #
####################################################
'

sudo apt install php mysql-server php-mysql php-xml php-intl

echo '
####################################################
# Installation de la suite apache, symfony etc. OK #
####################################################
'

mkdir ~/bin
echo bin >> ~/.hidden
echo 'Installation de composer : https://getcomposer.org/download/
    - do not forget --filename=composer --install-dir=$HOME/bin'
read y

echo "Installation du programme symfony : http://symfony.com/doc/current/setup.html"
read y

echo "Installation de nodejs : https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions"
read y

echo "Installation de npm (automatique) : "
sudo npm install npm -g
sudo chown -R $USER:$(id -gn $USER) /home/pauka/.config
sudo npm install less -g


echo "Press enter to end the script..."
read y

exit 0
