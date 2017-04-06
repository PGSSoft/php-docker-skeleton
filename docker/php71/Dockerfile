FROM php:7.1-fpm

MAINTAINER Michał Kruczek <mkruczek@pgs-soft.com>

ARG USERID=1000

RUN usermod -u $USERID www-data && \
    mkdir -p /var/www && \
    chown -R www-data:www-data /var/www && \
    chmod 777 -R /var/www

RUN apt-get -qq update --fix-missing && \
    apt-get -q install -y \
        zlib1g-dev \
        libicu-dev \
        g++ \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxml2-dev \
        libxslt1-dev \
        libc-client-dev \
        libkrb5-dev \
        cloc \
        git-core \
        && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-install zip iconv intl mysqli gd mbstring pdo_mysql xsl opcache imap

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

RUN pear channel-discover pear.phing.info && \
    pear install --alldeps phing/phing

COPY php.ini /usr/local/etc/php
COPY entrypoint.sh /entrypoint.sh

VOLUME /var/www
WORKDIR /var/www
USER www-data

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
