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
#FROM wordpress:latest

#RUN git clone RUN git clone https://github.com/DeanLennard/wordpress.git

#COPY ./html /var/www/html

# copy custom config files
#COPY my-custom-config.php /var/www/html/wp-config.php

# set permissions
#RUN chown -R www-data:www-data /var/www/html

# expose thje default wordpress port
#EXPOSE 80

# start wordpress
#CMD ["apache2-foreground"]

FROM wordpress:latest-apache

EXPOSE 80
# Use the PORT environment variable in Apache configuration files.
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf
# wordpress conf
COPY wordpress/wp-config.php /var/www/html/wp-config.php

# download and install cloud_sql_proxy
RUN apt-get update && apt-get install net-tools wget && \
    wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O /usr/local/bin/cloud_sql_proxy && \ 
    chmod +x /usr/local/bin/cloud_sql_proxy

# custom entrypoint
COPY wordpress/cloud-run-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["cloud-run-entrypoint.sh","docker-entrypoint.sh"]
CMD ["apache2-foreground"]