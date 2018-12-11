# PHP & Nginx Dockerfile

This Dockerfile contain PHP72 and lastest Nginx version base on Ubuntu 16.04.

## Build Image

```sh
git clone git@github.com:aisuhua/docker-php-nginx.git
cd docker-php-nginx
docker build -t php72 .
```

## Start Container

```sh
docker run -d --name suhua -p 80:80 php72
```

Binding the directory

```sh
docker run -d --name suhua -v /www/web:/www/web -p 80:80 suhua
```

Entering the container

```sh
docker exec -i -t php72 /bin/bash
```

You can clear the container

```sh
docker rm -f php72
```

## Links

- [docker-nginx-php](https://github.com/fideloper/docker-nginx-php)
- [nginx-php-fpm](https://github.com/richarvey/nginx-php-fpm)

