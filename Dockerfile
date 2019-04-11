FROM php:7.3-fpm-alpine

WORKDIR /app

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin -- --filename=composer

RUN apk update && \
    apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev curl-dev libedit-dev libxml2-dev icu-dev gettext-dev libsodium-dev icu-libs libsodium libgd gd-dev libwebp zlib libxpm libwebp-dev zlib-dev libxpm-dev libjpeg jpeg-dev libzip-dev imagemagick-dev make nodejs npm autoconf build-base libzip imagemagick git imap imap-dev openssl-dev openssl
RUN NPROC=$(getconf _NPROCESSORS_ONLN) && \
  docker-php-ext-configure zip --with-libzip && \
  docker-php-ext-configure imap --with-imap --with-imap-ssl && \
  docker-php-ext-install -j${NPROC} iconv curl bcmath json mbstring pdo_mysql opcache readline xml intl gettext opcache exif calendar mysqli sodium zip imap
RUN NPROC=$(getconf _NPROCESSORS_ONLN) && \
    docker-php-ext-configure gd \
     --with-jpeg-dir=/usr/include --with-png-dir=/usr/include --with-webp-dir=/usr/include --with-freetype-dir=/usr/include && \
    docker-php-ext-install -j${NPROC} gd 
RUN pecl install imagick && docker-php-ext-enable imagick
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev curl-dev libedit-dev libxml2-dev icu-dev libsodium-dev gd-dev libwebp-dev zlib-dev libxpm-dev jpeg-dev libzip-dev imagemagick-dev
COPY php.ini /usr/local/etc/php/
