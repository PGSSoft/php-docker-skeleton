#!/usr/bin/env bash

function runBuild {
    export IMAGE_VERSION=$1
    export PROJECT_XDEBUG_ENABLED=${2:-false}
    BUILD_OUTPUT=$(docker-compose up php)
    docker-compose kill > /dev/null 2>&1
    docker-compose rm -f -v > /dev/null 2>&1

    echo -e "$BUILD_OUTPUT";
    if echo "$BUILD_OUTPUT" | grep -q "exited with code 0"; then
        BUILD_STATUS=0;
    else
        BUILD_STATUS=1;
    fi
}
