#!/bin/bash

sudo apt install --reinstall mysql-server mysql-client mysql-common

cnf_file="$HOME/.my.cnf"
[ -f "$cnf_file" ] && mv "$cnf_file" "$cnf_file".old
log.py "Stoping mysql"
sudo service mysql stop

log.py "Removing mysql files"
sudo rm -rf /var/lib/mysql

log.py "Creating folder"
sudo mkdir /var/lib/mysql

log.py "Setting user for folder"
sudo chown mysql:mysql /var/lib/mysql

log.py "Setting permission for folder"
sudo chmod 775 /var/lib/mysql

log.py "Initialize insecure with mysqld"
sudo mysqld --initialize-insecure --user=mysql

log.py "Starting mysql server"
sudo service mysql start

log.py "Setting the secure connection"
mysql_secure_installation

[ -f "$cnf_file".old ] && mv "$cnf_file".old "$cnf_file"

[ -f "$cnf_file" ] && log.py -l CRITICAL "Please ensure that your ~/.my.cnf is correctly setup"

exit 0
