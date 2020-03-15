#!/bin/sh
echo "Nuking current installation..."
docker rm -f $(docker ps -a -q);
rm -Rf data
rm -Rf logs
rm -Rf www

