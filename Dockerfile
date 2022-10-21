FROM php:8.0-fpm

ARG user=clinics

RUN apt update \
    && apt install -y zlib1g-dev g++ git libicu-dev libpq-dev zip libzip-dev zip libpng-dev \
    && usermod -u 1000 www-data \
    && docker-php-ext-install intl opcache pdo pdo_mysql

RUN pecl install apcu \
    && pecl install xdebug-3.1.1 \
    && docker-php-ext-enable xdebug  \
    && docker-php-ext-enable apcu \
    && docker-php-ext-configure zip \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN groupadd $user
RUN useradd -g $user -G root -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user 

WORKDIR /var/www/docker


USER $user

