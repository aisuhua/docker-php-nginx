# PHP Development Environment

This Dockerfile contain PHP7.2 and lastest Nginx version base on Ubuntu16.04.

**Notice:** It's just for test.

## Build

```sh
git clone git@github.com:aisuhua/docker-php-nginx.git
cd docker-php-nginx
docker build -t phpdev .
```

After built the image，you can check it:

```sh
docker images
```

## Usage

Basic usage.

```sh
docker run -d --name php72 -v /path/to/project:/www/web -p 80:80 phpdev
```

Get into the container

```sh
docker exec -i -t php72 /bin/bash
```

You can clear the container and start a new container again.

```sh
docker rm -f php72
```

Check the status of PHP and Nginx.

- http://localhost/phpfpm_status
- http://localhost/nginx_status

## Links

- [docker-nginx-php](https://github.com/fideloper/docker-nginx-php)
- [nginx-php-fpm](https://github.com/richarvey/nginx-php-fpm)

