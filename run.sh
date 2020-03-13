#!/bin/bash


chgrp -R www-data /var/www/html
# chgrp -R www-data /var/www/html/bootstrap/cache
# chmod -R 777 /var/www/html/app/storage

# mkdir /var/www/html/invoice/resources/libraries/MPDF57/tmp
# chmod -R 777 /var/www/html/invoice/resources/libraries/MPDF57/tmp

# composer install --no-scripts

rm /run/apache2/apache2.pid
exec /usr/sbin/apache2ctl -D FOREGROUND