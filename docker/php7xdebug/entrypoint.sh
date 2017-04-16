#!/bin/bash -e

echo "ENABLED_XDEBUG = ${ENABLED_XDEBUG}"
if [ $ENABLED_XDEBUG == 'OFF' ]; then
    echo ';zend_extension=xdebug.so' > /usr/local/etc/php/conf.d/docker-php-pecl-xdebug.ini
fi

sleep 10;
if [ "$GITHUB_TOKEN" != "" ]; then composer config -g github-oauth.github.com ${GITHUB_TOKEN}; fi
composer install --prefer-dist --no-interaction --no-progress --ignore-platform-reqs
phing build
