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

sudo apt-get install apt-transport-https
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

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
#############################
# Ajout du ppa de nextcloud #
#############################
'
sudo add-apt-repository -y ppa:nextcloud-devs/client
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
git sublime-text \
nextcloud-client nextcloud-client-nautilus \
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

rm -rf examples.desktop Modèles Public

# Configuration of sublime text
echo '{
    "ensure_newline_at_eof_on_save": true,
    "word_wrap": false,
}' > "$HOME/.config/sublime-text-3/Packages/User/Preferences.sublime-settings"

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
sudo chown -R $USER:$(id -gn $USER) $HOME/.config
sudo npm install less -g


echo "Press enter to end the script..."
read y

exit 0
