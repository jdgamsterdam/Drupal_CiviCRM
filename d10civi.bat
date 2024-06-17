call env.bat

:: The Base URL should actually be "http://localhost" if you have not edited the Docker Host Hosts File to matchup.  The only thing that really needs a FQDN is the MySQL Database. 

:: The following installs and Enables Civi
docker exec drupal cv core:install --cms-base-url="http://localhost" --db="mysql://%mysqluser%:%mysqlpassword%@%mysqlfqdn%:3306/%drupaldatabasename%"

::This is needed to create the menus - Because CiviCRM is partially created in the Dockerile this directory does not get created at the right time 
docker exec drupal mkdir /opt/drupal/web/sites/default/files/civicrm/persist/contribute/dyn
docker exec drupal drush cr

::Need to get permissions and Can't mix Windows and Linux in container.  To get menus to work make sure your server has write permissions to /web/sites/default/files/civicrm/persist/contribute

docker exec drupal chmod -R 777 /opt/drupal/web/sites/default/files

docker cp civicrmextra.txt drupal:/opt/drupal/web/sites/default/civicrmextra.txt
docker exec drupal /bin/sh -c "cat /opt/drupal/web/sites/default/civicrmextra.txt >> /opt/drupal/web/sites/default/civicrm.settings.php"

:: The civicrm:publish is the CRUCIAL step to get things to install correctly
docker exec drupal composer civicrm:publish
docker exec drupal composer -W update
:: 644 is the Correct setting for the civicrm.settings.php file but will still get error during updatedb
docker exec drupal chmod 644 /opt/drupal/web/sites/default/civicrm.settings.php
docker exec drupal drush -y updatedb
docker exec drupal cv flush
docker exec drupal drush cr
::Fix install error drupal 10.  Not important but gets rid of warning
docker exec drupal drush sql:query "ALTER TABLE civicrm_install_canary ADD PRIMARY KEY (id)"






