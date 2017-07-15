#!/usr/bin/env bash

function runInBackground {
    export IMAGE_VERSION=$1
    export PROJECT_XDEBUG_ENABLED=${2:-false}

    docker-compose -f docker-compose.yml -f docker-compose.local.yml kill > /dev/null 2>&1
    docker-compose -f docker-compose.yml -f docker-compose.local.yml rm -f -v > /dev/null 2>&1
    docker-compose -f docker-compose.yml -f docker-compose.local.yml up -d nginx php mysql
    docker-compose -f docker-compose.yml -f docker-compose.local.yml exec php bash
    docker-compose -f docker-compose.yml -f docker-compose.local.yml kill > /dev/null 2>&1
    docker-compose -f docker-compose.yml -f docker-compose.local.yml rm -f -v > /dev/null 2>&1
}
