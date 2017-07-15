#!/bin/bash -e

echo "PROJECT_XDEBUG_ENABLED = $PROJECT_XDEBUG_ENABLED"
if [ $PROJECT_XDEBUG_ENABLED == false ]; then
    echo -e "Disabling xdebug\n";
    echo ';zend_extension=xdebug.so' > /usr/local/etc/php/conf.d/docker-php-pecl-xdebug.ini
fi

if [ "$GITHUB_TOKEN" != "" ]; then composer config -g github-oauth.github.com ${GITHUB_TOKEN}; fi

composer install --prefer-dist --no-interaction --no-progress
phing
