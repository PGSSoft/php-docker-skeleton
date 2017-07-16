#!/bin/bash

declare -i BUILD_STATUS=0;

echo "PROJECT_XDEBUG_ENABLED = ${PROJECT_XDEBUG_ENABLED}"
if [ $PROJECT_XDEBUG_ENABLED == false ]; then
    echo -e "Disabling xdebug\n";
    echo ';zend_extension=xdebug.so' > /usr/local/etc/php/conf.d/docker-php-pecl-xdebug.ini
fi

if [ "$GITHUB_TOKEN" != "" ]; then composer config -g github-oauth.github.com ${GITHUB_TOKEN}; fi

if ! composer install --prefer-dist --no-interaction --no-progress; then
    BUILD_STATUS=1
fi

if ! phing; then
    BUILD_STATUS=1
fi

chown -R "${PROJECT_USER_ID}:${PROJECT_GROUP_ID}" .

exit $BUILD_STATUS;
