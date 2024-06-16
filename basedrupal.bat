:: Store Defaults and Passwords in env.bat
call env.bat

::drop container if it exists
docker rm --force drupal

::need to create custom drupalfile that supports native mysql drivers for civicrm

cd .\drupalcomposer
docker build -t drupalwithmysqlnd .

cd ..

docker-compose -f basedrupal-compose.yml up -d
docker exec drupal apt-get -y update

::Drush SI should Delete old databsae and create new one if your database is currently running
:: For whatever reason CiviCRM seems much happier to install on a database with a Fully Qualified Domain Name (FQDN)so make sure to use one when spinning up Docker container

docker exec drupal drush -y si --db-url=mysql://%mysqluser%:%mysqlpassword%@%mysqlfqdn%:3306/%drupaldatabasename%

:: Set the Drush Admin Password
docker exec drupal drush user-password admin "%drupaladminpassword%"
docker exec drupal chmod -R 777 /opt/drupal/web/sites/default/files/

:: Add the modules you will be using in your standard development.  If you are certain of these you could add these to the Dockerfile so you only need to build once. 
call customdevmodules.bat

::Run Batch for any requirements for the current modules you are working on. 
cd \Projects-Drupal\cytoscape\
::call cytoscapechart.bat

:: Note Do not do composer -W update until AFTER civi is installed or all the elements in the dockerfile will be deleted
cd \Projects-Drupal\
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
docker exec drupal drush genc 10 