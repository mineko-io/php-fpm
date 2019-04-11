FROM php:7.4-fpm-alpine

WORKDIR /app

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin -- --filename=composer

RUN apk update && \
    apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev curl-dev libedit-dev libxml2-dev icu-dev gettext-dev libsodium-dev icu-libs libsodium libgd gd-dev libwebp zlib libxpm libwebp-dev zlib-dev libxpm-dev libjpeg jpeg-dev libzip-dev imagemagick-dev make nodejs npm autoconf build-base libzip imagemagick git imap imap-dev openssl-dev openssl krb5-dev
RUN NPROC=$(getconf _NPROCESSORS_ONLN) && \
  PHP_OPENSSL=yes docker-php-ext-configure imap --with-imap --with-imap-ssl --with-kerberos && \
  docker-php-ext-install -j${NPROC} iconv curl bcmath json pdo_mysql opcache readline xml intl gettext opcache exif calendar mysqli sodium zip imap
RUN NPROC=$(getconf _NPROCESSORS_ONLN) && \
    docker-php-ext-configure gd \
     --with-freetype --with-jpeg && \
    docker-php-ext-install -j${NPROC} gd 
RUN pecl install imagick && docker-php-ext-enable imagick && pecl install apcu
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev curl-dev libedit-dev libxml2-dev icu-dev libsodium-dev gd-dev libwebp-dev zlib-dev libxpm-dev jpeg-dev libzip-dev imagemagick-dev krb5-dev
COPY php.ini /usr/local/etc/php/
