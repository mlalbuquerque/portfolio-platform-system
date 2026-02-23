FROM php:8.4-fpm-alpine

RUN apk add --no-cache \
    icu-dev \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    mariadb-client

RUN docker-php-ext-install \
    intl \
    gd \
    zip \
    pdo_mysql

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/projects/{{PROJECT_NAME}}
