#!/bin/bash
#@author: werkn / werkncode.com / github.com/werkn
# Setup www-data as the owner of apps, change as 
# required, note this is required for docker in some
# instances
chown -R www-data /var/www/html ; chgrp -R www-data /var/www/html/ 
