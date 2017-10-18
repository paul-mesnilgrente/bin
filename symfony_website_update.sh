#!/bin/bash

function usage {
    echo "USAGE:"
    echo "    $0 website_folder writable_folders"
    echo "DESCRIPTION"
    echo "    writable folders are assumed to be in web"
    echo "    there is no need to write <web/folder>, just write <folder>"
}

if [ ${#} -eq 0 ]; then
    echo "ERROR: missing argument"
    usage; exit 1
fi
if [ ! -d ${1} ]; then
    echo "ERROR: \"${1}\" is not a folder"
    usage; exit 2
fi

website_folder=${1}
shift
cd ${website_folder}
for arg in ${@}; do
    if [ ! -d web/${arg} ]; then
        echo "ERROR: \"${arg}\" is not a folder"
        usage; exit 3
    fi
done

echo "CONFIGURATION:"
echo "    website_folder: $website_folder"
i=1
for folder in ${@}; do
    echo "    writable folder ${i}: ${folder}"
    i=`expr ${i} + 1`
done

# take the update from github
cp composer.lock /tmp
git pull
if [ ! ${?} -eq 0 ]; then
    echo "ERROR: couldn't pull the source code"
    echo "Resolve the issue and rerun the update script"
    exit 1
fi

diff composer.lock /tmp/composer.lock &> /dev/null
if [ ${?} -ne 0 ]; then
    composer install
fi
# clear the cache
php bin/console cache:clear --env=prod --no-warmup
php bin/console cache:clear --env=dev --no-warmup

# update the css/js, should do nothing
php bin/console assetic:dump --env=prod --no-debug

printf "Do you want to reset the database (y/n)? "
read answer
if [ ${answer} = 'y' ]; then
    for folder in ${@}; do
        rm -rf web/${folder}/* &> /dev/null
    done
    php bin/console doctrine:database:drop --force
    php bin/console doctrine:database:create
    php bin/console doctrine:schema:update --force
    echo y | php bin/console doctrine:fixture:load
else
    php bin/console doctrine:schema:update --force
    if [ ! ${?} -eq 0 ]; then
        echo "It seems that you cannot update your database schema."
        echo "BECAREFULL, the website may be broken!"
    fi
fi

HTTPDUSER=$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d ' ' -f1)

sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX var
sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX var
for folder in ${@}; do
    sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX web/${folder}
    sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX web/${folder}
done

exit 0
