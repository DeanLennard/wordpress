FROM php:8.2-apache

RUN apt-get update&& apt-get upgrade -yy \
&& apt-get install --no-insatall-recommends libjpeg-dev libpng-dev libwebp-dev \
libzip-dev libfreetype6-dev supervision zip \
unzip software-properties-common -yy \
&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN docker-php-ext-configure zip --with-libzip \
&& docker-php-ext-install mbstring gd mysqli pdo pdo-mysql \
&& docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr -- with-webp-dir=/usr \
&& docker-php-ext-install -j "$(nproc)" gd \
&& a2enmod rewrite

WORKDIR /val/www/html
COPY ./app /var/www/html