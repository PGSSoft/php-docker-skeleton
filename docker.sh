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
declare -i BUILD_STATUS=0;

function imageExists {
    IMAGE_NAME=$1
    if docker history -q "$IMAGE_NAME" > /dev/null 2>&1; then
        echo - "$IMAGE_NAME already exist"
        return 1;
    fi

    return 0;
}

function buildImages {
    NAME=$1
    VERSION=$2
    USERID=${3:-1000}
    PHP=${4-:"all"}

    imageExists "${NAME}:${VERSION}-php56"
    if [[ $? == 0 ]] && [[ "$PHP" == "php56" || "$PHP" == "all" ]]; then
        docker build -t "${NAME}:${VERSION}-php56" --build-arg USERID="$USERID" docker/php56
    fi

    imageExists "${NAME}:${VERSION}-php7"
    if [[ $? == 0 ]] && [[ "$PHP" == "php7" || "$PHP" == "all" ]]; then
        docker build -t "${NAME}:${VERSION}-php7" --build-arg USERID="$USERID" docker/php7
    fi

    imageExists "${NAME}:${VERSION}-php7xdebug"
    if [[ $? == 0 ]] && [[ "$PHP" == "php7xdebug" || "$PHP" == "all" ]]; then
        docker build -t "${NAME}:${VERSION}-php7xdebug" --build-arg "USERID=$USERID" docker/php7xdebug
    fi

    imageExists "${NAME}:${VERSION}-nginx"
    if [[ $? == 0 ]]; then
        docker build -t "${NAME}:${VERSION}-nginx" docker/nginx
    fi
}

function runBuild {
    export IMAGE_VERSION=$1
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

function runInBackground {
    export IMAGE_VERSION=$1
    docker-compose -f docker-compose.yml -f docker-compose.local.yml kill > /dev/null 2>&1
    docker-compose -f docker-compose.yml -f docker-compose.local.yml rm -f -v > /dev/null 2>&1
    docker-compose -f docker-compose.yml -f docker-compose.local.yml up -d nginx
    docker-compose -f docker-compose.yml -f docker-compose.local.yml exec -it php bash
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
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "all"
        ;;
    'build')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php7"
        runBuild "${APP_NAME}:${APP_VERSION}-php7"
        ;;
    'build-coverage')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php7xdebug"
        runBuild "${APP_NAME}:${APP_VERSION}-php7xdebug"
        ;;
    'build-56')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php56"
        runBuild "${APP_NAME}:${APP_VERSION}-php56"
        ;;
    'run')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php7"
        runInBackground "${APP_NAME}:${APP_VERSION}-php7"
        ;;
    'run-coverage')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php7xdebug"
        runInBackground "${APP_NAME}:${APP_VERSION}-php7xdebug"
        ;;
esac

echo -e "Script finished with exit code: ${BUILD_STATUS}";
exit $BUILD_STATUS;
