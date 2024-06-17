:: Store Defaults and Passwords in env.bat
call env.bat

::drop container if it exists
docker rm --force drupal

::need to create custom Dockerfile that supports native mysql drivers for CiviCRM
::Have chosen to use MySQL rather than MariaDB for development as it seems to play better with the Docker install. 

docker build -t drupal_civi_mysql -f Drupal_Civi_Dockerfile .
docker-compose -f basedrupal-compose.yml up -d
docker exec drupal apt-get -y update

::The Drush SI should Delete old database and create new one if your database is currently running
:: For whatever reason CiviCRM seems much happier to install on a database with a Fully Qualified Domain Name (FQDN)so make sure to use one when spinning up Docker container

docker exec drupal drush -y si --db-url=mysql://%mysqluser%:%mysqlpassword%@%mysqlfqdn%:3306/%drupaldatabasename%

:: Set the Drush Admin Password
docker exec drupal drush user-password admin "%drupaladminpassword%"
docker exec drupal chmod -R 777 /opt/drupal/web/sites/default/files/

:: Add the modules you will be using in your standard development.  If you are certain of these you could add these to the Dockerfile so you only need to build once. 
call customdevmodules.bat

::Run Batch for any requirements for the current modules you are working on. 
call currentdevelopment.bat

:: Note Do not do composer -W update until AFTER civi is installed or all the elements in the dockerfile will be deleted

call d10civi.bat

::Run Batch for Final Modules that you may have forgotten earlier.  

call finalmodules.bat

::generate random pages for testing

::In order to Generate files the Temp Directory needs to be set correctly so add a setting to the end of the settings.php

docker exec drupal mkdir /opt/drupal/web/sites/default/files/tmp

:: The Website www-data needs to own the files.  This may not be always  true in Production 
docker exec drupal chown -R www-data:www-data /opt/drupal/web/sites/default/files
docker cp settingsxtra.txt drupal:/opt/drupal/web/sites/default/settingsxtra.txt
docker exec drupal /bin/sh -c "cat /opt/drupal/web/sites/default/settingsxtra.txt >> /opt/drupal/web/sites/default/settings.php"

docker exec drupal composer -W update
docker exec drupal drush cr

::Generating some sample pages is useful for development and also a good double check if everything is installed correctly. 
docker exec drupal drush genc 10 