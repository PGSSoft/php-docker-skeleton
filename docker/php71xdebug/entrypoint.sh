#!/bin/bash -e

sleep 10;
if [ "$GITHUB_TOKEN" != "" ]; then composer config -g github-oauth.github.com ${GITHUB_TOKEN}; fi
composer install --prefer-dist --no-interaction --no-progress --ignore-platform-reqs
phing build
