This is to help one create a combined Drupal and CiviCRM container for DEVELOPMENT purposes.  THIS IS NOT FOR PRODUCTION USE. Some of the directories have been opened to ease the installation. 
The "Process" creates a container with the latest of everything.  If you want a different version of Drupal or CiviCRM it should be possible to edit, but it may break things.

For this project I chose to use MySQL rather than MariaDB.  For a number of reasons it just seemed easier to get to work.  THere is an example docker compose file for this (mysql-compose-example.yml). One of the big things is that CiviCRM is much happier when you have a Fully Qualified Domain Name (e.g. mysite.com) for the Database server. 

In general there are comments in each of the files to explain what they are used for but the following will try to explain each of Files / Directories. 

NOTE: This is a Script Setting for a WINDOWS HOST.  However, the .bat files should be relatively easy to convert to .sh script files in Linux if that is your host environment. 

0. Env.bat
This contains all the variables (e.g. your passwords) wanted for the development

1. Drupal_Civi_Dockerfile
   The Dockerfile used to create the base repository using the latest Drupal docker repository as a base.  Contains all the base install for CiviCRM. Once you are certain about what Modules you would want for your standard development platform (customdevmodules.bat), you could move all these into the dockerfile. 

2. drupal.ini 
   This contains custom settings for your development php.ini. Installed in the Dockerfile (above)

3. basedrupal.bat
   Runs everything to create the Base Drupal Development container. NOTE: Line 10 of that builds the base container using the dockerfile (above). Once it it is the way you want it, you can comment out that line from the script. 

4. settingsxtra.txt
   Extra items that must be enabled in the Drupal settings.php file for your environment.  NOTE. This does not replace items, it just adds them at the end.  If you need to CHANGE something it needs to be updated in a different way.

5. customdevmodules.bat
   These are all the specific "extra" modules that you like to use in your development or production environment for testing

6. d10civi.bat
   This contains all the small necessary changes that are need to get CiviCRM to install and work. 

7. civicrmextra.txt

   Extra items that must be enabled in the civicrm.settings.php file for your environment.  NOTE. This does not replace items, it just adds them at the end.  If you need to CHANGE something it needs to be updated in a different way.

8. finalmodules.bat
   These are just modules that were forgotten or need to be installed at the end because they may have some dependencies.