#!/bin/sh
#install our git repo, where $1 is the path to GitHub repo to install

#if nuke option is set, blow away all containers
#erase existing installation
if [[ "$2" == "--nuke" ]]; 
then 
	echo "Nuking current installation..."
	docker rm -f $(docker ps -a -q);
	rm -Rf data
	rm -Rf logs
	rm -Rf www
fi

#setup folders, clone repo
mkdir data ; mkdir data/mysql 
mkdir logs ; mkdir logs/mysql; mkdir logs/apache2; mkdir logs/php
mkdir www ; cd www
git clone $1 

#copy our test_database_connection.php
cp ./../test-database-connection.php .

#dump the readme to the console if it exists in the repo specifically we use an html comment
#to communicate post config operations when using docker
#ie: somewhere in your readme add #docker-post-install-msg: YOUR MESSAGE HERE, URL, ETC...
if [[ -e $(basename ${1})/README.md ]]; 
then 
	echo "Dumping README.md docker-post-install-msg for repo ($1)"
	cat $(basename ${1})/README.md | grep 'docker-post-install-msg' | sed -n "s/^.*'\(.*\)'.*$/\1/ p"
fi

cd ..

echo "Bringup up LAMP stack + installed web app for ($1)"

# set environment variables for export
set -a
# export secrets from .env (access within docker-compose using environment: -VARIABLENAME)
source .env

# bring up docker containers + app
docker-compose up -d ; 
docker cp ./bin/webserver/apache2/build-sites-enabled-confs.sh werkn-apache-webserver:/etc/apache2/ ;
docker exec -it werkn-apache-webserver bash /etc/apache2/build-sites-enabled-confs.sh