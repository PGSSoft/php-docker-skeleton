#!/usr/bin/env bash

TASK_NAME=$1;

export PROJECT_NAME=$(cat ./.project_name)
export PROJECT_WEB_DIR=${PROJECT_WEB_DIR:="web"}
export PROJECT_INDEX_FILE=${PROJECT_INDEX_FILE:="index.php"}
export PROJECT_DEV_INDEX_FILE=${PROJECT_DEV_INDEX_FILE:="index_dev.php"}
export APP_NAME=$(echo $(cat composer.json | grep name | head -1 | awk -F: '{ print $2 }' | sed 's/[",\r]//g' | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]'))
export APP_VERSION=$(echo $(cat composer.json | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[",\r]//g'))
export USERID=$(id -u);
echo "User ID: $USERID";
echo -e "\nIMAGE VERSION: $APP_NAME:$APP_VERSION\n";
declare -i BUILD_STATUS

function buildImages {
    NAME=$1
    VERSION=$2
    USERID=${3:-1000}

    docker build -t "${NAME}:${VERSION}-php7" --build-arg USERID="$USERID" docker/php7
    docker build -t "${NAME}:${VERSION}-php7xdebug" --build-arg USERID="$USERID" docker/php7xdebug
    docker build -t "${NAME}:${VERSION}-php56" --build-arg USERID="$USERID" docker/php56
    docker build -t "${NAME}:${VERSION}-node" docker/node
    docker build -t "${NAME}:${VERSION}-nginx" docker/nginx
    docker images
    docker ps -a
}

function runBuild {
    export IMAGE_VERSION=$1
    docker-compose up node
    BUILD_STATUS=$(docker-compose up php)
    docker-compose kill > /dev/null 2>&1
    docker-compose rm -f -v > /dev/null 2>&1

    echo -e "$BUILD_STATUS";
    if echo "$BUILD_STATUS" | grep -q "exited with code 0"; then
        return 0;
    else
        return 1;
    fi

}

function runInBackground {
    export IMAGE_VERSION=$1
    docker-compose -f docker-compose.yml -f docker-compose.local.yml kill > /dev/null 2>&1
    docker-compose -f docker-compose.yml -f docker-compose.local.yml rm -f -v > /dev/null 2>&1
    docker-compose -f docker-compose.yml -f docker-compose.local.yml up -d node
    docker-compose -f docker-compose.yml -f docker-compose.local.yml up -d nginx
    docker-compose -f docker-compose.yml -f docker-compose.local.yml run --entrypoint /bin/bash php
    docker-compose -f docker-compose.yml -f docker-compose.local.yml kill > /dev/null 2>&1
    docker-compose -f docker-compose.yml -f docker-compose.local.yml rm -f -v > /dev/null 2>&1
}

if [[ $TASK_NAME == '' ]]; then
    echo -e "Available commands:";
    echo -e "'build-images' - building docker images";
    echo -e "'run' - is running dev env and attaching tty";
    echo -e "'run-coverage' - is running dev env with xdebug and attaching tty";
    echo -e "'build' - is running build ant tasks based on php 7";
    echo -e "'build-coverage' - is running build ant tasks based on php 7 with code coverage";
    echo -e "'build-56' - is running build ant tasks based on php 5.6";
fi

case $TASK_NAME in
    'build-images')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}"
        ;;
    'build')
        runBuild "${APP_NAME}:${APP_VERSION}-php7"
        ;;
    'build-coverage')
        runBuild "${APP_NAME}:${APP_VERSION}-php7xdebug"
        ;;
    'build-56')
        runBuild "${APP_NAME}:${APP_VERSION}-php56"
        ;;
    'run')
        runInBackground "${APP_NAME}:${APP_VERSION}-php7"
        ;;
    'run-coverage')
        runInBackground "${APP_NAME}:${APP_VERSION}-php7xdebug"
        ;;
esac

BUILD_STATUS=$?

echo -e "Script finished with exit code: ${BUILD_STATUS}";
exit $BUILD_STATUS;
