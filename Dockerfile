FROM ubuntu:16.04

USER root

# https://github.com/phpdocker-io/phpdocker.io/issues/159
ARG DEBIAN_FRONTEND=noninteractive
ARG LC_ALL=C.UTF-8

ADD conf/sources.list /etc/apt/sources.list

RUN apt-get update && apt-get install -y tzdata
ENV tz Asia/Shanghai
RUN cp /usr/share/zoneinfo/$tz /etc/localtime && echo $tz | tee /etc/timezone

RUN apt-get update
RUN apt-get install -y \
software-properties-common \
build-essential \
python-software-properties \
vim \
curl \
wget \
git \
inetutils-ping \
net-tools

RUN add-apt-repository -y ppa:ondrej/php
RUN add-apt-repository -y ppa:nginx/stable
RUN add-apt-repository -y ppa:ondrej/pkg-gearman
RUN apt-get update

RUN apt-get install -y \
php7.2-common \
php7.2-dev \
php7.2-cli \
php7.2-fpm \
php7.2-xml \
php7.2-curl \
php7.2-mbstring \
php7.2-bcmath \
php7.2-gd \
php7.2-bz2 \
php7.2-zip \
php7.2-dba \
php7.2-mysql \
php7.2-soap \
php-pear \
php-imagick \
php-msgpack \
php-igbinary \
php-mongodb \
php-memcache \
php-memcached \
php-redis \
php-amqp \
php-phalcon \
php-xdebug \
php-gearman

RUN apt-get install -y libcurl4-gnutls-dev && \
	pecl install yar && \
	echo "extension=yar.so" >/etc/php/7.2/mods-available/yar.ini && \
	phpenmod -v 7.2 yar

RUN wget http://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-4-amd64.deb && \
dpkg -i couchbase-release-1.0-4-amd64.deb && \
apt-get update && \
apt-get install -y libcouchbase-dev zlib1g-dev && \
rm couchbase-release-1.0-4-amd64.deb && \
pecl install couchbase && \
echo 'extension=couchbase.so\n; priority=30' > /etc/php/7.2/mods-available/couchbase.ini && \
phpenmod -v 7.2 couchbase 



CMD ["/bin/bash", "-c", "while true; do echo hello world; sleep 1; done"]
