FROM php:7.1.20-apache

RUN apt-get -y update --fix-missing
RUN apt-get upgrade -y

#get tools
RUN apt-get -y install apt-utils vim tmux wget dialog

RUN apt-get -y install --fix-missing apt-utils build-essential git

RUN apt-get -y install libmcrypt-dev
RUN docker-php-ext-install mcrypt
RUN apt-get -y install mysql-client
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli

# Enable apache modules
RUN a2enmod rewrite headers
