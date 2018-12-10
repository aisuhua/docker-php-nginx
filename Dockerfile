FROM ubuntu:16.04

USER root

# Apt
ADD conf/sources.list /etc/apt/sources.list

# Timezone
RUN apt-get update && apt-get install -y tzdata
ENV tz Asia/Shanghai
RUN cp /usr/share/zoneinfo/$tz /etc/localtime && echo $tz | tee /etc/timezone

# Softwares
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

RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:nginx/stable
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/pkg-gearman
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
php-xdebug \
php-gearman

CMD ["/bin/bash", "-c", "while true; do echo hello world; sleep 1; done"]
