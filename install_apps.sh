#!/bin/bash

set -e

function require_action {
    log.py -l ERROR "${1}"
    printf "Press enter to continue... "
    read y
}

log.py -l ERROR 'Removing useless packages'
sudo apt autoremove --purge -y ubuntu-web-launchers totem shotwell shotwell-common

log.py 'Adding sublime text ppa'
sudo apt install -y apt-transport-https
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# log.py 'Adding oracle java ppa'
# sudo add-apt-repository -y ppa:webupd8team/java

log.py 'Adding nextcloud ppa'
sudo add-apt-repository -y ppa:nextcloud-devs/client

log.py 'Adding darktable ppa'
sudo add-apt-repository -y ppa:pmjdebruijn/darktable-release

log.py 'Adding LibreOffice ppa'
sudo add-apt-repository -y ppa:libreoffice/ppa

log.py 'Adding NodeJS ppa'
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

log.py 'Update and upgrade packages'
sudo apt update && sudo apt -y upgrade

log.py 'Install basic softwares and libraries'
    # oracle-java8-installer \
sudo apt install -y \
    easytag ttf-mscorefonts-installer \
    vlc gimp gnome-chess grisbi gparted \
    sublime-text nextcloud-client telegram-desktop \
    nextcloud-client-nautilus darktable nodejs \
    php mysql-server php-mysql php-xml php-intl

log.py 'Installing composer'
install_composer.sh

log.py 'Installing symfony'
sudo curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
sudo chmod a+x /usr/local/bin/symfony

log.py 'Updating NPM'
sudo npm install npm -g
sudo npm install less -g

log.py 'Installing Messenger'
wget 'https://updates.messengerfordesktop.com/download/linux/latest/beta?arch=amd64&pkg=deb' \
 -O messenger.deb
sudo apt install -y ./messenger.deb
rm messenger.deb

log.py 'Installing Whatsapp'
log.py -l ERROR 'Nothing working without installing google chrome'

log.py 'Installing Skype'
sudo snap install --classic skype

log.py 'Installing Slack'
sudo snap install --classic slack

require_action 'System :
    - Install languages
    - Modify the background
    - Add workspaces
    - Install proprietary softwares (e.g):
        - Intel microcode,
        - NVidia drivers
    - Put sleep mode to never'

require_action 'Mozilla thunderbird :
    - Add email accounts
    - Install extensions :
        - Lightning, 
        - Enigmail,
        - CardBook.'

require_action 'Mozilla firefox :
    - Install lastpass,
    - Remove bookmarks,
    - Synchro firefox,
    - Go on https://startpage.com/ and set it up,
    - Add starpage as default search engine,
    - Remove other search engines,
    - Configure wallabag,
    - Add the bookmark toolbar,
    - Enable "use autoscrolling",
    - Add the search bar,
    - Configure vertical bar.'

require_action 'Sublime text :
    - Install the package control (one click in sublime),
    - Install markdown preview, LESS.'

require_action 'Launch and configure Nextcloud.'

[ -f examples.desktop ] && rm -rf examples.desktop
[ -d Templates ] && rm -rf Templates
[ -d Public ] && rm -rf Public
grep '^bin$' ~/.hidden &> /dev/null || echo bin >> ~/.hidden
grep '^snap$' ~/.hidden &> /dev/null || echo snap >> ~/.hidden

require_action "End of the script."

exit 0
