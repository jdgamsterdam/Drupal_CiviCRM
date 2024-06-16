::Add any Final Modules that Don't require special edits to the composer.json file (e.g. without libraries)
docker exec drupal composer require drupal/twiggy
docker exec drupal composer require drupal/rest_views
docker exec drupal composer require drupal/views_better_rest

docker exec drupal drush en twiggy
docker exec drupal drush en rest_views
docker exec drupal drush en views_better_rest

::Remove the import directory if it exists
docker exec drupal rm -r /opt/drupal/web/sites/default/files/config_base_new2
docker exec drupal mkdir /opt/drupal/web/sites/default/files/config_base_new2
docker cp ./startassetsfinal/. drupal:/opt/drupal/web/sites/default/files/config_base_new2/
docker exec drupal drush config:import --partial --source=/opt/drupal/web/sites/default/files/config_base_new2