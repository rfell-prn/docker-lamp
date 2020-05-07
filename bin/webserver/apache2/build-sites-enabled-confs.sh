#!/bin/bash
#@author: werkn / werkncode.com / github.com/werkn
# Script generates a .htpasswd file (user + pass)
# and configures virtual host based on environment variables
# set in .env



#setup initial password file
read -p "Configure .htpasswd password protection?  ([Yy]es or [Nn]o)" -n 1 -r
echo #move cursor to newline
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Enter username to use for authentication:"
    read htuser
    echo #move cursor to newline
    htpasswd -c /etc/apache2/.htpasswd ${htuser}
fi

#stop apache so we can remove existing sites-enabled
service apache2 stop

#remove any existing confs from /etc/apache2/sites-enabled
rm -Rf /etc/apache2/sites-enabled

if [[ -e /etc/apache2/.htpasswd ]]
then

#setup sites-enabled + auth
bash -c "cat >> /etc/apache2/sites-enabled/000-default.conf" << EOF
<VirtualHost *:80>
    ServerAdmin $APACHE_SERVER_ADMIN_EMAIL
    DocumentRoot $APACHE_DOCUMENT_ROOT
    ServerName $APACHE_SERVER_NAME
        <Directory $APACHE_DOCUMENT_ROOT>
            AuthType Basic
            AuthName "Restricted Content ~~LAMP"
            AuthUserFile /etc/apache2/.htpasswd
            Require valid-user
        </Directory>
</VirtualHost>
EOF

else

#setup sites-enabled, no auth
bash -c "cat >> /etc/apache2/sites-enabled/000-default.conf" << EOF
<VirtualHost *:80>
    ServerAdmin $APACHE_SERVER_ADMIN_EMAIL
    DocumentRoot $APACHE_DOCUMENT_ROOT
    ServerName $APACHE_SERVER_NAME
        <Directory $APACHE_DOCUMENT_ROOT>
        </Directory>
</VirtualHost>
EOF

fi

#restart apache
service apache2 restart
