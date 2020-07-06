FROM php:5.4.34-apache
ENV PORT=80

RUN apt-get update && \
    apt-get install libjpeg-dev libfreetype6-dev libpng-dev libmcrypt-dev libicu-dev g++ git zip unzip dos2unix -y --force-yes

RUN docker-php-ext-install mcrypt && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    docker-php-ext-install pdo pdo_mysql mysql mysqli && \
    docker-php-ext-install gd && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install zip && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install XDebug
COPY xdebug-2.4.0.tgz /var/tmp
WORKDIR /var/tmp
RUN tar -xzf xdebug-2.4.0.tgz

WORKDIR /var/tmp/xdebug-2.4.0
RUN phpize
RUN ./configure --enable-xdebug
RUN make && make install

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "[XDebug]" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN more /usr/local/etc/php/conf.d/xdebug.ini

RUN echo "memory_limit=-1" > /usr/local/etc/php/conf.d/maxmem.ini

RUN chown -R www-data:www-data /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html

RUN a2enmod rewrite

WORKDIR /var/www/html
VOLUME ["/var/www/html"]

EXPOSE ${PORT}
EXPOSE 9000

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data

COPY run.sh /run.sh

RUN dos2unix /run.sh && \
    chmod 777 /run.sh
CMD ["/run.sh"]
