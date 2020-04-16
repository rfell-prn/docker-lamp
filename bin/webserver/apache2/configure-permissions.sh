#!/bin/bash
#@author: werkn / werkncode.com / github.com/werkn
# Setup www-data as the owner of apps, change as 
# required, note this is required for docker in some
# instances

read -p "Make www-data own every in /var/www/html?  ([Yy]es or [Nn]o)" -n 1 -r
echo #move cursor to newline
if [[ $REPLY =~ ^[Yy]$ ]]
then
    chown -R www-data /var/www/html/* ; chgrp -R www-data /var/www/html/* 
fi
