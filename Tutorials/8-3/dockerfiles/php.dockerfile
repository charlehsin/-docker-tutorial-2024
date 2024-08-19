FROM php:7.4-fpm-alphine

WORKDIR /var/www/html

RUN docker-php-ext-install pdo pdo_mysql