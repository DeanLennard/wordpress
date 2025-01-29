#FROM php:8.2-apache

#RUN apt-get update&& apt-get upgrade -yy \
#&& apt-get install --no-insatall-recommends libjpeg-dev libpng-dev libwebp-dev \
#libzip-dev libfreetype6-dev supervision zip \
#unzip software-properties-common -yy \
#&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN docker-php-ext-configure zip --with-libzip \
#&& docker-php-ext-install mbstring gd mysqli pdo pdo-mysql \
#&& docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr -- with-webp-dir=/usr \
#&& docker-php-ext-install -j "$(nproc)" gd \
#&& a2enmod rewrite

#WORKDIR /val/www/html
#COPY ./app /var/www/html

# use the offical wordpres image as the base
FROM wordpress:latest

COPY ./html /var/www/html

# copy custom config files
#COPY my-custom-config.php /var/www/html/wp-config.php

# set permissions
RUN chown -R www-data:www-data /var/www/html

# expose thje default wordpress port
EXPOSE 80

# start wordpress
CMD ["apache2-foreground"]