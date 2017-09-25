#!/bin/bash

# take the update from github
cd /var/www/registration_app
sudo chown -R ${USER}:${USER} .
cp composer.json /tmp
git pull
if [ ! $? -eq 0 ]; then
    echo "ERROR: couldn't pull the source code"
    echo "Resolve the issue and rerun the update script"
else
    diff composer.json /tmp/composer.json > /dev/null
    if [ $? -ne 0 ]; then
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
        rm -rf web/qr_codes/* web/video/* web/faces/* web/database/* 2> /dev/null
        php bin/console doctrine:database:drop --force
        php bin/console doctrine:database:create
        php bin/console doctrine:schema:update --force
        echo y | php bin/console doctrine:fixture:load
    else
        php bin/console doctrine:schema:update --force
        if [ ! $? -eq 0 ]; then
            echo "It seems that you cannot update your database schema."
            echo "BECAREFULL, the website may be broken!"
        fi
    fi

    sudo chown -R www-data:www-data .
fi

exit 0
