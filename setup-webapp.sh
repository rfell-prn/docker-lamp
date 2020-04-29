#!/bin/sh
#install our git repo, where $1 is the path to GitHub repo to install

#if nuke option is set, blow away all containers
#erase existing installation
if [[ "$2" == "--nuke" ]]; 
then 
	echo "Nuking current installation..."
	sudo docker rm -f $(sudo docker ps -a -q);
	rm -Rf data
	rm -Rf logs
	rm -Rf www
fi

#setup folders, clone repo
mkdir data ; mkdir data/mysql 
mkdir logs ; mkdir logs/mysql; mkdir logs/apache2; mkdir logs/php
mkdir www ; cd www

#clone repo
git clone $1 

#get our folder name
repoFolderName=$(basename ${1})

#change into our www dir
#all dockerized apps use branch docker-setup,
#check that branch out
cd ${repoFolderName} 
git checkout docker-setup

#dump the readme to the console if it exists in the repo specifically we use an html comment
#to communicate post config operations when using docker
#ie: somewhere in your readme add #docker-post-install-msg: YOUR MESSAGE HERE, URL, ETC...
if [[ -e README.md ]]; 
then 
	echo "Dumping README.md docker-post-install-msg for repo ($1)"
	cat README.md | grep 'docker-post-install-msg' | sed -n "s/^.*'\(.*\)'.*$/\1/ p"
fi

cd ../..

echo "Bringup up LAMP stack + installed web app for ($1)"

pwd

# set environment variables for export
set -a
# export secrets from .env (access within docker-compose using environment: -VARIABLENAME)
source .env

# bring up docker containers + app
sudo docker-compose up -d

# make sure container is running before proceeding
echo "Waiting for docker containers to come up before proceeding..."
sleep 20s

#if www/appname has a install.sh, run it it contains post config scripts
if [[ -e ./www/${repoFolderName}/install.sh ]]; 
then 
	echo "Running post install script for app: $(basename ${1})" 
	sudo docker exec -it werkn-apache-webserver bash /var/www/html/${repoFolderName}/install.sh
fi

#make sure our web app is owned by www-data (fix for upload folder permissions)
sudo docker cp ./bin/webserver/apache2/configure-permissions.sh werkn-apache-webserver:/etc/apache2/ 

#copy into web server config script for .htpasswd
sudo docker cp ./bin/webserver/apache2/build-sites-enabled-confs.sh werkn-apache-webserver:/etc/apache2/ 

#run script in interactive shell
sudo docker exec -it werkn-apache-webserver bash /etc/apache2/configure-permissions.sh
sudo docker exec -it werkn-apache-webserver bash /etc/apache2/build-sites-enabled-confs.sh
