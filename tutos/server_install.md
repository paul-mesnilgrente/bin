# Serveur

## Environment

```bash
sudo apt update && sudo apt upgrade
sudo apt install -y git vim
ssh-keygen -t rsa -b 4096
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub
echo "Add the ssh key to your github account..."; read y
git clone git@github.com:/paul-mesnilgrente/bin ~/bin
config_env.sh
export PATH=$PATH:$HOME/bin
echo '
export PATH=$PATH:$HOME/bin' > ~/.bashrc
```

## Serveur web

```bashrc
sudo apt install -y apache2 php mysql-server libapache2-mod-php php-mysql
```

## Symfony et composer

```bash
# Symfony
sudo mkdir -p /usr/local/bin
sudo curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
sudo chmod a+x /usr/local/bin/symfony

# Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=$HOME/bin --filename=composer
php -r "unlink('composer-setup.php');"
```

## NodeJS et NPM

- https://nodejs.org/en/download/package-manager/

```bash
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install npm -g
sudo npm install less -g
```

## Letsencrypt

```bash
sudo install -y software-properties-common
sudo add-apt-repository -y ppa:certbot/certbot
sudo apt update
sudo apt install -y python-certbot-apache
sudo a2enmod ssl
sudo service apache2 restart

# Each time there is a new website
sudo certbot --apache
# To test that the automatic renewal is working
sudo certbot renew --dry-run

# Configure the CRON for automatic renewal every 15 minutes
(crontab -l 2>/dev/null; echo "*/15 * * * * certbot renew") | sudo crontab -
```

## NextCloud

- https://nextcloud.com/install/
- https://docs.nextcloud.com/server/12/admin_manual/installation/
- le script est plutôt susceptible de changer


```bash
wget https://download.nextcloud.com/server/releases/nextcloud-12.0.0.zip
wget https://download.nextcloud.com/server/releases/nextcloud-12.0.0.zip.md5
[ "`md5sum nextcloud-12.0.0.zip`" = "`cat nextcloud-12.0.0.zip.md5`" ] && echo OK || echo NOK

# installation of prerequisities
sudo apt install -y php-gd php-json php-mysql php-curl php-mbstring
sudo apt install -y php-intl php-mcrypt php-imagick php-xml php-zip

# install nextcloud
mv nextcloud /var/www/nextcloud
echo '<VirtualHost *:80>
    ServerName nextcloud.paul-mesnilgrente.com

    DocumentRoot /var/www/nextcloud/
    <Directory /var/www/nextcloud/>
        Options +FollowSymlinks
        AllowOverride All
        Satisfy Any

        <IfModule mod_dav.c>
            Dav off
        </IfModule>

        SetEnv HOME /var/www/nextcloud
        SetEnv HTTP_HOME /var/www/nextcloud
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/nextcloud_error.log
    CustomLog ${APACHE_LOG_DIR}/nextcloud_access.log combined
</VirtualHost>' > /etc/apache2/sites-available/nextcloud.conf
sudo a2ensite nextcloud.conf

# install required and recommanded modules
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod env
sudo a2enmod dir
sudo a2enmod mime

service apache2 restart

# enable SSL
sudo certbot --apache -d nextcloud.paul-mesnilgrente.com
sudo service apache2 reload

sudo chown -R www-data:www-data /var/www/nextcloud/

sudo mysql -u root -p
```

```mysql
CREATE DATABASE db_nextcloud;
CREATE USER "user-nextcloud"@"localhost";
SET password FOR "user-nextcloud"@"localhost" = password("rQuRoEu7YVdxjVriA8fVGSPNHQWqECJn2");
GRANT ALL ON db_nextcloud.* TO "user-nextcloud"@"localhost";
```

```bash
echo 'Go on the page nextcloud.paul-mesnilgrente.com and complete the configuration'; read y

# Warning tip for ".htaccess not working"
echo '
# personnalized
# https://central.owncloud.org/t/how-to-fix-the-htaccess-file-does-not-work-message/823
deny from all
IndexIgnore *' > /var/www/nextcloud/data/.htaccess

# Warning Op cache not properly configured
# https://docs.nextcloud.com/server/12/admin_manual/configuration_server/server_tuning.html
echo '
; personnalized
opcache.enable=1
opcache.enable_cli=1
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.memory_consumption=128
opcache.save_comments=1
opcache.revalidate_freq=1' >> /etc/php/7.0/apache2/php.ini

echo 'If SSL is enable add this in the ssl virtualhost:
<IfModule mod_headers.c>
    Header always set Strict-Transport-Security "max-age=15552000; includeSubDomains"
</IfModule>'; read y

# Configure cache
apt install -y php-apcu
echo "Add this line to the config.php: 'memcache.local' => '\OC\Memcache\APCu',"; read y;
sudo service apache2 restart

# CronJob
sudo -u www-data /var/www/nextcloud/occ background:cron
(crontab -l 2>/dev/null; echo "*/15  *  *  *  * php -f /var/www/nextcloud/cron.php") | crontab -u www-data -

echo 'Set your email: admin@paul-mesnilgrente.com'
echo 'Add this apps: Calendar, Contacts, Tasks'
echo 'Add the paul-mesnilgrente user and configure his email'
echo 'Synchronize devices'
read y
```

## Wallabag

```mysql
CREATE DATABASE db_wallabag;
CREATE USER "user-wallabag"@"localhost";
SET password FOR "user-wallabag"@"localhost" = password("q7dw9OKUpquh3eB7dw35GRqLxZkqZsDlDmFnPNx3CSRvG257hOG2oCDX");
GRANT ALL ON db_wallabag.* TO "user-wallabag"@"localhost";
```

- http://doc.wallabag.org/en/master/user/installation.html

```bash
sudo apt install -y php-json php-gd php-mbstring php-xml php-tidy php-curl php-gettext php-bcmath
git clone https://github.com/wallabag/wallabag.git
cd wallabag
export SYMFONY_ENV=prod
make install
```

```text
Creating the "app/config/parameters.yml" file
Some parameters are missing. Please provide them.
database_driver (pdo_sqlite): pdo_mysql
database_host (127.0.0.1): 
database_port (null): 
database_name (symfony): db_wallabag
database_user (root): user-wallabag
database_password (null): q7dw9OKUpquh3eB7dw35GRqLxZkqZsDlDmFnPNx3CSRvG257hOG2oCDX
database_path ('%kernel.root_dir%/../data/db/wallabag.sqlite'): ~
database_table_prefix (wallabag_): 
database_socket (null): 
mailer_transport (smtp): smtp
mailer_host (127.0.0.1): mail.gandi.net
mailer_user (null): contact@paul-mesnilgrente.com
mailer_password (null): YXPQMv^fJ2UwdfW*uIOoSk49gtSbgpQe!%a!imAFmjHi4#miOkgG!AosqJaYY6znF534ssGTXgZ8@M4rRNWf2jR1I%f
locale (en): 
secret (ovmpmAWXRCabNlMgzlzFXDYmCFfzGv): 
twofactor_auth (true): 
twofactor_sender (no-reply@wallabag.org): 
fosuser_registration (true): 
fosuser_confirmation (true): 
from_email (no-reply@wallabag.org): wallabag@paul-mesnilgrente.com
rss_limit (50): 
rabbitmq_host (localhost): 
rabbitmq_port (5672): 
rabbitmq_user (guest): 
rabbitmq_password (guest): 
redis_scheme (tcp): 
redis_host (localhost): 
redis_port (6379): 
redis_path (null):
```

```xml
<VirtualHost *:80>
    ServerName wallabag.paul-mesnilgrente.com

    DocumentRoot /var/www/wallabag/web
    <Directory /var/www/wallabag/web>
        AllowOverride None
        Order Allow,Deny
        Allow from All

        <IfModule mod_rewrite.c>
            Options -MultiViews
            RewriteEngine On
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule ^(.*)$ app.php [QSA,L]
        </IfModule>
    </Directory>

    # uncomment the following lines if you install assets as symlinks
    # or run into problems when compiling LESS/Sass/CoffeScript assets
    # <Directory /var/www/wallabag>
    #     Options FollowSymlinks
    # </Directory>

    # optionally disable the RewriteEngine for the asset directories
    # which will allow apache to simply reply with a 404 when files are
    # not found instead of passing the request into the full symfony stack
    <Directory /var/www/wallabag/web/bundles>
        <IfModule mod_rewrite.c>
            RewriteEngine Off
        </IfModule>
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/wallabag_error.log
    CustomLog ${APACHE_LOG_DIR}/wallabag_access.log combined
</VirtualHost>
```

```bash
sudo mv wallabag /var/www/
sudo chown -R www-data:www-data /var/www/wallabag/var
sudo chown -R www-data:www-data /var/www/wallabag/bin
sudo chown -R www-data:www-data /var/www/wallabag/app/config
sudo chown -R www-data:www-data /var/www/wallabag/vendor
sudo chown -R www-data:www-data /var/www/wallabag/data/
sudo a2ensite wallabag.conf
sudo service apache2 reload
sudo certbot --apache -d wallabag.paul-mesnilgrente.com
sudo certbot renew --dry-run

echo "Navigate to the developper menu and create a client for firefox synchronization"; read y
```


## FreshRSS

- https://github.com/FreshRSS/FreshRSS

### Configuration MySQL

```mysql
CREATE DATABASE db_freshrss;
CREATE USER "user-freshrss"@"localhost";
SET password FOR "user-freshrss"@"localhost" = password("D3S9imKFLj4t9IZddy0ZmVXtIz8pYygGWfjZUl3P5xpZN1o6jBtrpvZJgKqgcxk");
GRANT ALL ON db_freshrss.* TO "user-freshrss"@"localhost";
```

### Ajout du contenu

```bash
sudo apt install -y php libapache2-mod-php php-curl php-gmp php-intl php-mbstring php-xml php-zip
sudo a2enmod headers expires rewrite ssl
# For FreshRSS itself (git is optional if you manually download the installation files)
cd /var/www
sudo apt install -y git
sudo git clone https://github.com/FreshRSS/FreshRSS.git
# Set the rights so that your Web browser can access the files
cd FreshRSS
sudo chown -R :www-data .
sudo chmod -R g+w ./data/

# add of apache configuration
echo '<VirtualHost *:80>
    ServerName rss.paul-mesnilgrente.com
    DocumentRoot /var/www/FreshRSS/p

    ErrorLog ${APACHE_LOG_DIR}/freshrss_error.log
    CustomLog ${APACHE_LOG_DIR}/freshrss_access.log combined
</VirtualHost>' > /etc/apache2/sites-available/FreshRSS.conf

sudo a2ensite FreshRSS
sudo certbot --apache -d freshrss.paul-mesnilgrente.com
```

- Autoriser les authentifications par API pour la synchro smartphone
- Mettre un cron pour faire la mise a jour automatiquement

### Mise a jour automatique du contenu

```bash
(crontab -l 2>/dev/null; echo "p*/30 * * * * hp /usr/share/FreshRSS/app/actualize_script.php") | crontab -u www-data -
```

### Synchronisation avec EasyRSS

1. Aller dans paramètres > Authentification > Cocher "Autoriser l'accès par API"
2. Aller dans paramètres > Profil > Définir un mot de passe API
3. Tester si l'adresse API fonctionne au moins partiellement (ça doit afficher PASS)
4. Rentrer les informations sur le téléphone dans l'appli EasyRSS
    - URL : https://rss.paul-mesnilgrente.com/api/greader.php
    - Utilisateur : FreshRSS
    - Mot de passe : le mot de passe API entrée dans l'étape 3

## GitLab

- https://about.gitlab.com/downloads/#ubuntu1604

### Pré-requis

```bash
sudo apt install -y ruby-full # il faut que la version soit >= 2.3
sudo apt install -y curl openssh-server ca-certificates postfix
// je ne suis pas sur que la suite des pré-requis soit obligatoire !
// voir : premier paragraphe https://about.gitlab.com/installation/
sudo apt install -y postgresql postgresql-contrib
// editer le fichier /etc/postgresql/9.5/main/pg_hba.conf
// pour que la methode soit en md5 pour les 3 dernières lignes
sudo /etc/init.d/postgresql restart
sudo -i -u postgres
echo 'Enter password for new role: 
Enter it again: 
Shall the new role be a superuser? (y/n) n
Shall the new role be allowed to create databases? (y/n) y
Shall the new role be allowed to create more new roles? (y/n) y'
createuser -P --interactive user-gitlab
createdb -O user-gitlab -E UTF8 db_gitlab
psql db_gitlab
CREATE EXTENSION pg_trgm;
deconnexion
CREATE EXTENSION pg_trgm;
```

### Installation

```bash
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
sudo apt install -y gitlab-ce
sudo a2enmod rewrite proxy proxy_http
sudo gitlab-ctl reconfigure
```

### Utilisation d'apache au lieu du nginx inclut dans le package

/etc/gitlab/gitlab.rb

```text
external_url 'http://gitlab.paul-mesnilgrente.com'
gitlab_workhorse['listen_network'] = "tcp"
gitlab_workhorse['listen_addr'] = "127.0.0.1:8181"
web_server['external_users'] = ['www-data']
nginx['enable'] = false
```
sudo gitlab-ctl reconfigure

```xml
# This configuration has been tested on GitLab 8.2
# Note this config assumes unicorn is listening on default port 8080 and
# gitlab-workhorse is listening on port 8181. To allow gitlab-workhorse to
# listen on port 8181, edit or create /etc/default/gitlab and change or add the following:
#
# gitlab_workhorse_options="-listenUmask 0 -listenNetwork tcp -listenAddr 127.0.0.1:8181 -authBackend http://127.0.0.1:8080"
#
#Module dependencies
# mod_rewrite
# mod_proxy
# mod_proxy_http
<VirtualHost *:80>
  ServerName gitlab.paul-mesnilgrente.com
  ServerSignature Off

  ProxyPreserveHost On

  # Ensure that encoded slashes are not decoded but left in their encoded state.
  # http://doc.gitlab.com/ce/api/projects.html#get-single-project
  AllowEncodedSlashes NoDecode

  <Location />
    # New authorization commands for apache 2.4 and up
    # http://httpd.apache.org/docs/2.4/upgrading.html#access
    Require all granted

    #Allow forwarding to gitlab-workhorse
    ProxyPassReverse http://127.0.0.1:8181
    ProxyPassReverse http://gitlab.paul-mesnilgrente.com/
  </Location>

  # Apache equivalent of nginx try files
  # http://serverfault.com/questions/290784/what-is-apaches-equivalent-of-nginxs-try-files
  # http://stackoverflow.com/questions/10954516/apache2-proxypass-for-rails-app-gitlab
  RewriteEngine on

  #Don't escape encoded characters in api requests
  RewriteCond %{REQUEST_URI} ^/api/v3/.*
  RewriteRule .* http://127.0.0.1:8181%{REQUEST_URI} [P,QSA,NE]

  #Forward all requests to gitlab-workhorse except existing files like error documents
  RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f [OR]
  RewriteCond %{REQUEST_URI} ^/uploads/.*
  RewriteRule .* http://127.0.0.1:8181%{REQUEST_URI} [P,QSA]

  # needed for downloading attachments
  DocumentRoot /opt/gitlab/embedded/service/gitlab-rails/public

  #Set up apache error documents, if back end goes down (i.e. 503 error) then a maintenance/deploy page is thrown up.
  ErrorDocument 404 /404.html
  ErrorDocument 422 /422.html
  ErrorDocument 500 /500.html
  ErrorDocument 502 /502.html
  ErrorDocument 503 /503.html

  # It is assumed that the log directory is in /var/log/httpd.
  # For Debian distributions you might want to change this to
  # /var/log/apache2.
  LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %>s %b" common_forwarded
  ErrorLog  ${APACHE_LOG_DIR}/gitlab_error.log
  CustomLog ${APACHE_LOG_DIR}/gitlab_forwarded.log common_forwarded
  CustomLog ${APACHE_LOG_DIR}/gitlab_access.log combined env=!dontlog
  CustomLog ${APACHE_LOG_DIR}/gitlab.log combined
</VirtualHost>
```

ATTENTION un problème va intervenir au moment de cloner un projet :
    - UsePAM no dans /etc/ssh/sshd_config indique que git n'a pas le droit de se connecter en ssh
    - ceci est à cause du faite que git a un mot de passe
    - il faut remplacer le ! par un * dans /etc/shadown pour git
    - source : http://arlimus.github.io/articles/usepam/

### Configuration valable pour Gitlab

Dans le fichier /etc/gitlab/gitlab.rc

```text
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "mail.gandi.net"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_authentication'] = "plain"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_user_name'] = "contact@paul-mesnilgrente.com"
gitlab_rails['smtp_password'] = "mon_password"
gitlab_rails['smtp_domain'] = "paul-mesnilgrente.com"
```

- /etc/apache2/sites-available/gitlab.conf

```xml
<VirtualHost *:80>
  ServerName gitlab.paul-mesnilgrente.com
  ServerSignature Off

  RewriteEngine on
  RewriteCond %{HTTPS} !=on
  RewriteRule .* https://%{SERVER_NAME}%{REQUEST_URI} [NE,R,L]
</VirtualHost>
```

- /etc/apache2/sites-available/gitlab-le-ssl.conf

```xml
<IfModule mod_ssl.c>
<VirtualHost *:443>
  SSLEngine on
  #strong encryption ciphers only
  #see ciphers(1) http://www.openssl.org/docs/apps/ciphers.html
  SSLProtocol all -SSLv2
  SSLHonorCipherOrder on
  SSLCipherSuite "ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS"
  Header add Strict-Transport-Security: "max-age=15768000;includeSubdomains"
  SSLCompression Off
  SSLCertificateFile /etc/letsencrypt/live/owncloud.paul-mesnilgrente.com/fullchain.pem
  SSLCertificateKeyFile /etc/letsencrypt/live/owncloud.paul-mesnilgrente.com/privkey.pem
  # SSLCACertificateFile /etc/httpd/ssl.crt/your-ca.crt

  ServerName gitlab.paul-mesnilgrente.com
  ServerSignature Off

  ProxyPreserveHost On

  # Ensure that encoded slashes are not decoded but left in their encoded state.
  # http://doc.gitlab.com/ce/api/projects.html#get-single-project
  AllowEncodedSlashes NoDecode

  <Location />
    # New authorization commands for apache 2.4 and up
    # http://httpd.apache.org/docs/2.4/upgrading.html#access
    Require all granted

    #Allow forwarding to gitlab-workhorse
    ProxyPassReverse http://127.0.0.1:8181
    ProxyPassReverse http://gitlab.paul-mesnilgrente.com/
  </Location>

  # Apache equivalent of nginx try files
  # http://serverfault.com/questions/290784/what-is-apaches-equivalent-of-nginxs-try-files
  # http://stackoverflow.com/questions/10954516/apache2-proxypass-for-rails-app-gitlab
  RewriteEngine on

  #Forward all requests to gitlab-workhorse except existing files like error documents
  RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f [OR]
  RewriteCond %{REQUEST_URI} ^/uploads/.*
  RewriteRule .* http://127.0.0.1:8181%{REQUEST_URI} [P,QSA,NE]

  RequestHeader set X_FORWARDED_PROTO 'https'
  RequestHeader set X-Forwarded-Ssl on

  # needed for downloading attachments
  DocumentRoot /opt/gitlab/embedded/service/gitlab-rails/public

  #Set up apache error documents, if back end goes down (i.e. 503 error) then a maintenance/deploy page is thrown up.
  ErrorDocument 404 /404.html
  ErrorDocument 422 /422.html
  ErrorDocument 500 /500.html
  ErrorDocument 502 /502.html
  ErrorDocument 503 /503.html

  # It is assumed that the log directory is in /var/log/httpd.
  # For Debian distributions you might want to change this to
  # /var/log/apache2.
  LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %>s %b" common_forwarded
  ErrorLog  ${APACHE_LOG_DIR}/gitlab_error.log
  CustomLog ${APACHE_LOG_DIR}/gitlab_forwarded.log common_forwarded
  CustomLog ${APACHE_LOG_DIR}/gitlab_access.log combined env=!dontlog
  CustomLog ${APACHE_LOG_DIR}/gitlab.log combined

  Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>

</IfModule>
```
## Kanboard

```mysql
CREATE DATABASE db_kanboard;
CREATE USER "user-kanboard"@"localhost";
SET password FOR "user-kanboard"@"localhost" = password("e6cnNdSL4fdVuzKAZ7HvEbAZoVQGx4Cz8kN5ZLgvF5yxO6dOJVN1IRo2RhI0OTQpy8lfD0w004uE1ZNgvIFGTplWIUZhPqHZW");
GRANT ALL ON db_kanboard.* TO "user-kanboard"@"localhost";
```

```bash
sudo apt install -y apache2 libapache2-mod-php7.0 php7.0-cli php7.0-mbstring php7.0-sqlite3 php7.0-opcache php7.0-json php7.0-mysql php7.0-pgsql php7.0-ldap php7.0-gd
git clone https://github.com/kanboard/kanboard.git
cd kanboard && composer update
cd ..
sudo mv kanboard/ /var/www/
echo '<VirtualHost *:80>
    ServerName kanboard.paul-mesnilgrente.com
    DocumentRoot /var/www/kanboard

    ErrorLog ${APACHE_LOG_DIR}/kanboard_error.log
    CustomLog ${APACHE_LOG_DIR}/kanboard_access.log combined
</VirtualHost>' | sudo tee /etc/apache2/sites-available/kanboard.conf
sudo a2ensite kanboard.conf
sudo service apache2 reload
sudo chown -R www-data:www-data /var/www/kanboard/data
```

- Changer la configuration pour utiliser mysql au lieu sqlite.
- A la premiere requête sur l'adresse, il faut attendre longtemps car la configuration se fait, si c'est long, attendre encore !

## Wekan

De la merde à installer, donc non


## Piwik

```bash
wget https://builds.piwik.org/piwik.zip && unzip piwik.zip
sudo mv piwik /var/www/
rm piwik.zip
cd /etc/apache2/sites-available/
# creer les fichiers virtualhost
# mettre à jour les certificats letsencrypt pour le ssl
# sinon
sudo a2ensite piwik
sudo service apache2 reload
sudo chown -R www-data:www-data /var/www/piwik
sudo chmod -R 0755 /var/www/piwik/tmp
sudo chmod -R 0755 /var/www/piwik/tmp/assets/
sudo chmod -R 0755 /var/www/piwik/tmp/cache/
sudo chmod -R 0755 /var/www/piwik/tmp/logs/
sudo chmod -R 0755 /var/www/piwik/tmp/tcpdf/
sudo chmod -R 0755 /var/www/piwik/tmp/templates_c/
```

- /etc/apache2/sites-available/piwik.conf

```xml
<VirtualHost *:80>
    ServerName piwik.paul-mesnilgrente.com
    DocumentRoot /var/www/piwik

    ErrorLog ${APACHE_LOG_DIR}/piwik_error.log
    CustomLog ${APACHE_LOG_DIR}/piwik_access.log combined
</VirtualHost>
```

```mysql
CREATE DATABASE db_piwik;
CREATE USER "user-piwik"@"localhost";
SET password FOR "user-piwik"@"localhost" = password("QPuwV6ubLbNgkTr1pHdh7CnCr3aMWBlsSYQi0eII0NIh5Ji6eSrFlKznDr9MzdN4JF7MizmP9ppiMOrDanig9g");
GRANT ALL ON db_piwik.* TO "user-piwik"@"localhost";
```

- aller sur la page nouvellement installer
- le reste des étapes d'installation sont ici
- Enjoy

## Mise à jour automatique des dns gandi

```bash
git clone .../gandi-ddns
cd gandi-ddns
vim config.txt
```

```text
[local1]
apikey = IOED2xrk0M6QeonBcTt7iMyk
domain = paul-mesnilgrente.com
a_name = @
ttl = 900
api = https://rpc.gandi.net/xmlrpc/
host = localhost
[local2]
apikey = IOED2xrk0M6QeonBcTt7iMyk
domain = paul-mesnilgrente.com
a_name = *
ttl = 900
api = https://rpc.gandi.net/xmlrpc/
host = localhost
```

```bash
(crontab -l 2>/dev/null; echo "*/15 * * * * /home/paul/gandi-ddns/gandi-ddns.py") | sudo crontab -
```

## Subsonic

```bash
sudo apt install -y default-jdk
sudo dpkg -i subsonic-6.0.deb
sudo vim /etc/apache2/sites-available/subsonic.conf
sudo a2ensite subsonic.conf
sudo service apache2 restart

# création de l'utilisateur subsonic
```

```xml
<VirtualHost *:80>
    ServerAdmin webmaster@paul-mesnilgrente.com
    ServerName subsonic.paul-mesnilgrente.com

    DocumentRoot /var/subsonic
    <Directory /var/subsonic>
        Options Indexes ExecCGI FollowSymLinks
        Order allow,deny
        Allow from all
        AllowOverride all
    </Directory>
    
    # Permet de masquer la signature renvoyée par Apache
    ServerSignature Off

    # Directives concernant le Proxy que nous venons d'activer sur notre serveur
    <IfModule mod_proxy_http.c>
        ProxyRequests Off
        ProxyPreserveHost Off
        ProxyPass / http://localhost:4040/
        ProxyPassReverse / http://localhost:4040/
    </IfModule>

    # Vous pouvez renseigner ici les chemins de votre choix pour le stockage des logs
    ErrorLog ${APACHE_LOG_DIR}/subsonic_error.log
    CustomLog ${APACHE_LOG_DIR}/subsonic_access.log combined
</VirtualHost>
```

## Sonerezh

- https://www.sonerezh.bzh/docs/fr/installation.html#exemple-de-deploiement-sur-ubuntu-server

```bash
cd /var/www
sudo git clone --branch master https://github.com/Sonerezh/sonerezh.git
sudo chown -R www-data: sonerezh/
mysql -u root -p
```

```mysql
CREATE DATABASE db_sonerezh;
CREATE USER "user-sonerezh"@"localhost";
SET password FOR "user-sonerezh"@"localhost" = password("DUsXI0BrtBHSFCJQ5NFfRv9TQeAd9s33eFfaWau5O7OuK6I9YEHtqdcEKOM2615In5jI");
GRANT ALL ON db_sonerezh.* TO "user-sonerezh"@"localhost";
```

```bash
sudo a2enmod rewrite
sudo vim /etc/apache2/sites-available/sonerezh.conf
sudo a2ensite sonerezh && sudo service apache2 restart
sudo letsencrypt --apache
sudo apt install -y libav-tools

```

```xml
<VirtualHost *:80>
     ServerName      sonerezh.paul-mesnilgrente.com
     DocumentRoot    /var/www/sonerezh

     <Directory /var/www/sonerezh>
         Options -Indexes
         AllowOverride All
         <IfModule mod_authz_core.c>
             Require all granted
         </IfModule>
     </Directory>

     CustomLog   ${APACHE_LOG_DIR}/sonerezh_access.log "Combined"
     ErrorLog    ${APACHE_LOG_DIR}/sonerezh_error.log
 </VirtualHost>
 ```

## NDLI

```mysql
CREATE DATABASE db_ndli;
CREATE USER "user-ndli"@"localhost";
SET password FOR "user-ndli"@"localhost" = password("y1IcbShLpBrYayEyvVY2YQ5YXtam6C1bwNjHRQFWMA5Jdh1Degpndj1Wm9LwTMmcLr32y1dIlp2mCexV5");
GRANT ALL ON db_ndli.* TO "user-ndli"@"localhost";
```

```bash
cd ~
git clone git@github.com:paul-mesnilgrente/nuit-info-2016.git
cd nuit-info-2016
composer update
cd ..
mv nuit-info-2016 /var/www/
sudo chown -R www-data:www-data /var/www/nuit-info-2016/var
sudo chown -R www-data:www-data /var/www/nuit-info-2016/bin
sudo chown -R www-data:www-data /var/www/nuit-info-2016/app/config
sudo chown -R www-data:www-data /var/www/nuit-info-2016/vendor
```

```xml
<VirtualHost *:80>
    ServerName ndli.paul-mesnilgrente.com

    DocumentRoot /var/www/nuit-info-2016/web
    <Directory /var/www/nuit-info-2016/web>
        AllowOverride All
        Order Allow,Deny
        Allow from All
    </Directory>

    # uncomment the following lines if you install assets as symlinks
    # or run into problems when compiling LESS/Sass/CoffeeScript assets
    # <Directory /var/www/project>
    #     Options FollowSymlinks
    # </Directory>

    ErrorLog ${APACHE_LOG_DIR}/ndli_error.log
    CustomLog ${APACHE_LOG_DIR}/ndli_access.log combined
</VirtualHost>
```

```bash
sudo a2ensite ndli.conf
sudo certbot --apache -d ndli.paul-mesnilgrente.com
```

## Koel

```mysql
CREATE DATABASE db_koel;
CREATE USER "user-koel"@"localhost";
SET password FOR "user-koel"@"localhost" = password("...");
GRANT ALL ON db_koel.* TO "user-koel"@"localhost";
```

```bash
sudo npm install -g yarn
cd ~
git clone git@github.com:phanan/koel
cd koel
git checkout v3.6.2
composer install
php artisan koel:init
echo "Change the values in .env"; read y
mv nuit-info-2016 /var/www/
sudo chown -R www-data:www-data /var/www/koel
```

```xml
<VirtualHost *:80>
    ServerName koel.paul-mesnilgrente.com

    DocumentRoot /var/www/koel/web

    ErrorLog ${APACHE_LOG_DIR}/koel_error.log
    CustomLog ${APACHE_LOG_DIR}/koel_access.log combined
</VirtualHost>
```

```bash
sudo a2ensite koel.conf
sudo certbot --apache -d koel.paul-mesnilgrente.com
```
