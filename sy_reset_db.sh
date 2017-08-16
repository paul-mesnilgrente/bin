#!/bin/bash

source ~/.bashrc
source ~/bin/custom_output.sh

function write_step {
    echo -e ${OnGreen}${1}${Rst}
}

write_step 'Dropping the database...'
php bin/console doctrine:database:drop --force

write_step 'Creating the database...'
php bin/console doctrine:database:create

write_step 'Create the schema...'
php bin/console doctrine:schema:update --force

write_step 'Loading the data...'
echo y | php bin/console doctrine:fixture:load
