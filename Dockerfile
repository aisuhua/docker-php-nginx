FROM ubuntu:16.04

USER root

# https://github.com/phpdocker-io/phpdocker.io/issues/159
ARG DEBIAN_FRONTEND=noninteractive

ADD snippets/sources.list /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y tzdata locales

ENV tz Asia/Shanghai
RUN cp /usr/share/zoneinfo/$tz /etc/localtime && echo $tz | tee /etc/timezone

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

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

RUN add-apt-repository -y ppa:nginx/stable && \
apt-get update && \
apt-get install -y nginx

RUN apt-get install -y supervisor

RUN wget https://github.com/composer/composer/releases/download/1.8.0/composer.phar && \
mv composer.phar /usr/local/bin/composer && \
chmod 755 /usr/local/bin/composer && \
composer config -g repo.packagist composer https://packagist.phpcomposer.com

RUN mkdir -p /run/php
RUN sed -i "s/listen = .*/listen = 127.0.0.1:9000/" /etc/php/7.2/fpm/pool.d/www.conf
RUN sed -i "s/;pm.status_path = .*/pm.status_path = \/phpfpm_status/" /etc/php/7.2/fpm/pool.d/www.conf

RUN sed -i "s/;date.timezone =.*/date.timezone = PRC/" /etc/php/7.2/fpm/php.ini
RUN sed -i "s/upload_max_filesize =.*/upload_max_filesize = 30M/" /etc/php/7.2/fpm/php.ini
RUN sed -i "s/post_max_size =.*/post_max_size = 30M/" /etc/php/7.2/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = PRC/" /etc/php/7.2/cli/php.ini
RUN sed -i "s/upload_max_filesize =.*/upload_max_filesize = 30M/" /etc/php/7.2/cli/php.ini
RUN sed -i "s/post_max_size =.*/post_max_size = 30M/" /etc/php/7.2/cli/php.ini

ADD nginx /etc/nginx
RUN rm /etc/nginx/sites-enabled/default
RUN mkdir -p /www/web && \
chown -R www-data:www-data /www

ADD snippets/supervisord.conf /etc/supervisor/

RUN rm -rf /tmp/* /var/tmp/* && \
rm -rf /etc/php/5.6 /etc/php/7.0 /etc/php/7.1 /etc/php/7.3

WORKDIR /www/web

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
