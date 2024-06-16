::Add Basic Modules for Testing
docker exec drupal composer require drupal/devel
docker exec drupal composer require drupal/libraries
docker exec drupal composer require drupal/devel_debug_log
docker exec drupal composer require drupal/asset_injector
docker exec drupal composer require drupal/html_head
docker exec drupal composer require drupal/views_data_export
docker exec drupal composer require drupal/node_export

::docker exec drupal composer -w require drupal/ckeditor_codemirror:3.0.x-dev@dev
docker exec drupal composer -W require drupal/codemirror_editor
docker exec drupal composer -W require drupal/library_manager
docker exec drupal composer config --no-plugins allow-plugins.wikimedia/composer-merge-plugin true
docker exec drupal composer require --no-interaction wikimedia/composer-merge-plugin

::Uninstall unneeded Modules for development
docker exec drupal drush pm:uninstall automated_cron
docker exec drupal drush pm:uninstall big_pipe
docker exec drupal drush pm:uninstall announcements_feed

::install Modules for development
docker exec drupal drush en devel
docker exec drupal drush en devel_generate
docker exec drupal drush en libraries
docker exec drupal drush en serialization
docker exec drupal drush en devel_debug_log
docker exec drupal drush en asset_injector

::::docker exec drupal drush en ckeditor_codemirror
docker exec drupal drush en html_head
docker exec drupal drush en basic_auth jsonapi rest csv_serialization
docker exec drupal drush en views_data_export
docker exec drupal drush en codemirror_editor
docker exec drupal drush en library_manager
docker exec drupal drush en node_export

docker exec drupal drush cr

