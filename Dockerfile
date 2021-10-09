FROM ubuntu:20.04

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
vim \
curl \
wget \
git \
inetutils-ping \
net-tools

RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update

RUN apt-get install -y \
php7.4-common \
php7.4-dev \
php7.4-cli \
php7.4-fpm \
php7.4-xml \
php7.4-curl \
php7.4-mbstring \
php7.4-bcmath \
php7.4-gd \
php7.4-bz2 \
php7.4-zip \
php7.4-dba \
php7.4-mysql \
php7.4-soap \
php-pear \
php7.4-imagick \
php7.4-msgpack \
php7.4-igbinary \
php7.4-mongodb \
php7.4-memcache \
php7.4-memcached \
php7.4-redis \
php7.4-amqp \
php7.4-psr \
php7.4-xdebug

RUN pecl channel-update pecl.php.net && \
pecl install https://pecl.php.net/get/phalcon-4.1.2.tgz && \
echo "; priority=50" > /etc/php/7.4/mods-available/phalcon.ini && \
echo "extension=phalcon.so" >> /etc/php/7.4/mods-available/phalcon.ini && \
phpenmod -v 7.4 phalcon

RUN apt-get install -y libcurl4-gnutls-dev && \
pecl install http://pecl.php.net/get/yar-2.2.0.tgz && \
echo "extension=yar.so" >/etc/php/7.4/mods-available/yar.ini && \
phpenmod -v 7.4 yar

RUN add-apt-repository -y ppa:nginx/stable && \
apt-get update && \
apt-get install -y nginx

RUN apt-get install -y supervisor

RUN wget https://mirrors.aliyun.com/composer/composer.phar && \
mv composer.phar /usr/local/bin/composer && \
chmod 755 /usr/local/bin/composer && \
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

RUN mkdir -p /run/php
RUN sed -i "s/listen = .*/listen = 127.0.0.1:9000/" /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i "s/;pm.status_path = .*/pm.status_path = \/phpfpm_status/" /etc/php/7.4/fpm/pool.d/www.conf

RUN sed -i "s/;date.timezone =.*/date.timezone = PRC/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/upload_max_filesize =.*/upload_max_filesize = 30M/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/post_max_size =.*/post_max_size = 30M/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = PRC/" /etc/php/7.4/cli/php.ini
RUN sed -i "s/upload_max_filesize =.*/upload_max_filesize = 30M/" /etc/php/7.4/cli/php.ini
RUN sed -i "s/post_max_size =.*/post_max_size = 30M/" /etc/php/7.4/cli/php.ini

ADD nginx /etc/nginx
RUN rm /etc/nginx/sites-enabled/default
RUN mkdir -p /www/web && \
chown -R www-data:www-data /www

COPY snippets/supervisord.conf /etc/supervisor/

RUN rm -rf /tmp/* /var/tmp/* && \
rm -rf /etc/php/5.6 /etc/php/7.0 /etc/php/7.1 /etc/php/7.2 /etc/php/7.3 /etc/php/8.0

WORKDIR /www/web

EXPOSE 80

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
