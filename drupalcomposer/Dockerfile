# Start with the Drupal Docker File.  This is Pretty good and sets up most of the things correctly
FROM drupal:latest

# This containes a list of the packages need for civicrm as well as a number of basic libraries that are useful for developement.  
RUN apt-get update && apt-get install -y lsb-release wget libonig-dev libxml2-dev zip unzip wget gnupg unzip nano git wget jq iputils-ping

#The following .deb is used to setup the connection to Mysql.  It is theorhetically possible to use Maraidb, but for some some security and administration reasons, mysql is slightly better.

# There is no "latest" for the MYSQL requirements from Oracle so important that the name of the file matches with the install below

ARG CURRMYSQL=mysql-apt-config_0.8.30-1_all.deb

RUN ["/bin/bash", "-c", "wget -P /tmp https://dev.mysql.com/get/${CURRMYSQL}"]

# This is after the above list because some of the above are needed to install
RUN ["/bin/bash", "-c", "DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/${CURRMYSQL}"]

# Install system dependencies
RUN apt-get update && apt-get install -y mysql-shell mysql-community-client  

#DO Standard PHP extensions

RUN docker-php-ext-install mysqli pdo pdo_mysql

#Add GD and Graphics Extensions
# In theory these are already installed correctly in the Drupal Docker so don't override


#Add Latest Drush 
RUN ["/bin/bash", "-c", "composer require --dev drush/drush"]

#Civicrm Extras - Extra Packages and PHP packages needed for CIvicrm

RUN apt-get update && apt-get install -y libsodium-dev libzip-dev && docker-php-ext-install opcache sodium zip intl

#Put any extra PHP settings needed in the drupal.ini file

COPY drupal.ini /usr/local/etc/php/conf.d/

RUN ["/bin/bash", "-c", "pecl install apcu uploadprogress"]

# Set the Default Directory as writeable. THis is for Development so security is not such an issue
RUN chmod 777 /opt/drupal/web/sites/default

# Download all the latest CiviCrm packages and CLI Tools

RUN ["/bin/bash", "-c", "composer config extra.compile-mode all && composer config extra.enable-patching true && composer config minimum-stability dev && composer config --no-plugins allow-plugins.civicrm/civicrm-asset-plugin true && composer config --no-plugins allow-plugins.civicrm/composer-compile-plugin true && composer config --no-plugins allow-plugins.civicrm/composer-downloads-plugin true && composer config --no-plugins allow-plugins.cweagans/composer-patches true && composer require -W civicrm/civicrm-core && composer require -W civicrm/civicrm-packages && composer require -W civicrm/civicrm-drupal-8"]

RUN ["/bin/bash", "-c", "composer config --no-plugins allow-plugins.civicrm/composer-downloads-plugin true && composer require -W civicrm/cli-tools"]
