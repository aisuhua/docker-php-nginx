# Simplest PHP & Nginx Dockerfile

This Dockerfile contain PHP7.2 and lastest Nginx version base on Ubuntu16.04.

## Build

```sh
git clone git@github.com:aisuhua/docker-php-nginx.git
cd docker-php-nginx
docker build -t php72 .
```

## Usage

```sh
docker run -d --name suhua -p 80:80 php72
```

Bind to project dir `/www/web`. 

```sh
docker run -d --name php72 -v /path/to/project:/www/web -p 80:80 php72
```

Get into the container

```sh
docker exec -i -t php72 /bin/bash
```

You can clear the container and start a new container again.

```sh
docker rm -f php72
```

## Links

- [docker-nginx-php](https://github.com/fideloper/docker-nginx-php)
- [nginx-php-fpm](https://github.com/richarvey/nginx-php-fpm)

