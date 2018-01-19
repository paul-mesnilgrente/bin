#!/bin/bash

set -e

function require_action {
    presult.sh -f "${1}"
    printf "Press enter to continue... "
    read y
}

presult.sh -f 'Removing useless packages'
sudo apt autoremove --purge -y unity-webapps-common totem shotwell shotwell-common

presult.sh -s 'Adding sublime text ppa'
sudo apt install -y apt-transport-https
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

presult.sh -s 'Adding oracle java ppa'
# sudo add-apt-repository -y ppa:webupd8team/java

presult.sh -s 'Adding nextcloud ppa'
sudo add-apt-repository -y ppa:nextcloud-devs/client

presult.sh -s 'Adding darktable ppa'
sudo add-apt-repository -y ppa:pmjdebruijn/darktable-release

presult.sh -s 'Adding Telegram ppa'
sudo add-apt-repository -y ppa:atareao/telegram

presult.sh -s 'Adding NodeJS ppa'
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

presult.sh -s 'Update and upgrade packages'
sudo apt update && sudo apt -y upgrade

presult.sh -s 'Install basic softwares and libraries'
    # oracle-java8-installer \
sudo apt install -y nautilus-dropbox \
    easytag vim tree ttf-mscorefonts-installer \
    vlc gimp xournal gnome-chess grisbi gparted \
    libreoffice-java-common \
    git sublime-text nextcloud-client \
    nextcloud-client-nautilus curl libgnome2-bin \
    darktable python-pygments telegram \
    php mysql-server php-mysql php-xml php-intl nodejs

presult.sh -s 'Installing composer'
install_composer.sh

presult.sh -s 'Installing NPM'
sudo npm install npm -g
sudo chown -R $USER:$(id -gn $USER) $HOME/.config
sudo npm install less -g

presult.sh -s 'Installing Messenger'
wget 'https://updates.messengerfordesktop.com/download/linux/latest/beta?arch=amd64&pkg=deb' \
 -O messenger.deb
sudo apt install -y ./messenger.deb
rm messenger.deb

presult.sh -s 'Installing Whatsapp'
presult.sh -f 'Nothing working without installing google chrome'

presult.sh -s 'Installing Skype'
wget 'https://go.skype.com/skypeforlinux-64.deb'
sudo apt install -y ./skypeforlinux-64.deb
rm skypeforlinux-64.deb

presult.sh -s 'Installing Slack'
wget 'https://downloads.slack-edge.com/linux_releases/slack-desktop-3.0.5-amd64.deb'
sudo apt install -y ./slack-desktop-3.0.5-amd64.deb
rm slack-desktop-3.0.5-amd64.deb

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

require_action 'Install language tools.'

require_action 'Launch and configure Nextcloud.'

[ -f examples.desktop ] && rm -rf examples.desktop
[ -d Templates ] && rm -rf Templates
[ -d Public ] && rm -rf Public
[ ! -f ~/.hidden ] && echo bin >> ~/.hidden
[ `grep -c '^bin$' ~/.hidden` -eq 0 ] && echo bin >> ~/.hidden

require_action "End of the script."

exit 0
