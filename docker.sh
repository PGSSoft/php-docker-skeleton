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

    imageExists "${NAME}:${VERSION}-php56xdebug"
    if [[ $? == 0 ]] && [[ "$PHP" == "php56xdebug" || "$PHP" == "all" ]]; then
        docker build -t "${NAME}:${VERSION}-php56xdebug" --build-arg "USERID=$USERID" docker/php56xdebug
    fi

    imageExists "${NAME}:${VERSION}-php7"
    if [[ $? == 0 ]] && [[ "$PHP" == "php7" || "$PHP" == "all" ]]; then
        docker build -t "${NAME}:${VERSION}-php7" --build-arg USERID="$USERID" docker/php7
    fi

    imageExists "${NAME}:${VERSION}-php7xdebug"
    if [[ $? == 0 ]] && [[ "$PHP" == "php7xdebug" || "$PHP" == "all" ]]; then
        docker build -t "${NAME}:${VERSION}-php7xdebug" --build-arg "USERID=$USERID" docker/php7xdebug
    fi

    imageExists "${NAME}:${VERSION}-php71"
    if [[ $? == 0 ]] && [[ "$PHP" == "php71" || "$PHP" == "all" ]]; then
        docker build -t "${NAME}:${VERSION}-php71" --build-arg USERID="$USERID" docker/php71
    fi

    imageExists "${NAME}:${VERSION}-php71xdebug"
    if [[ $? == 0 ]] && [[ "$PHP" == "php71xdebug" || "$PHP" == "all" ]]; then
        docker build -t "${NAME}:${VERSION}-php71xdebug" --build-arg "USERID=$USERID" docker/php71xdebug
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
    docker-compose -f docker-compose.yml -f docker-compose.local.yml up -d nginx php mysql
    docker-compose -f docker-compose.yml -f docker-compose.local.yml exec php bash
    docker-compose -f docker-compose.yml -f docker-compose.local.yml kill > /dev/null 2>&1
    docker-compose -f docker-compose.yml -f docker-compose.local.yml rm -f -v > /dev/null 2>&1
}

if [[ $TASK_NAME == '' ]]; then
    echo -e "Available commands:";
    echo -e "'build-images' - building docker images";
    echo -e "'build' - is running build ant tasks based on php 7.1";
    echo -e "'pure-build' - build image php 7.1";
    echo -e "'build-coverage' - is running build ant tasks based on php 7.1 with code coverage";
    echo -e "'pure-build-coverage' - build image php 7.1 with xdebug";
    echo -e "'run' - is running dev env and attaching tty php 7.1";
    echo -e "'run-coverage' - is running dev env with php7.1, xdebug and attaching tty";
    echo -e "'build-71' - is running build ant tasks based on php 7.1";
    echo -e "'pure-build-71' - build image php 7.1";
    echo -e "'build-71-coverage' - is running build ant tasks based on php 7.1 with code coverage";
    echo -e "'pure-build-71-coverage' - build image php 7.1 with xdebug";
    echo -e "'run-71' - is running dev env and attaching tty php 7.1";
    echo -e "'run-71-coverage' - is running dev env with php7.1, xdebug and attaching tty";
    echo -e "'build-7' - is running build ant tasks based on php 7";
    echo -e "'pure-build-7' - build image php 7";
    echo -e "'build-7-coverage' - is running build ant tasks based on php 7 with code coverage";
    echo -e "'pure-build-7-coverage' - build image php 7 with xdebug";
    echo -e "'run-7' - is running dev env and attaching tty";
    echo -e "'run-7-coverage' - is running dev env with php7, xdebug and attaching tty";
    echo -e "'build-56' - is running build ant tasks based on php 5.6";
    echo -e "'pure-build-56' - build image php 5.6";
    echo -e "'build-56-coverage' - is running build ant tasks based on php 5.6 with code coverage";
    echo -e "'pure-build-56-coverage' - build image php 5.6 with xdebug";
    echo -e "'run-56' - is running dev env and attaching tty php 5.6";
    echo -e "'run-56-coverage' - is running dev env with php5.6, xdebug and attaching tty";
fi

case $TASK_NAME in
    'build-images')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "all"
        ;;
    'pure-build-56')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php56"
        ;;
    'build-56')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php56"
        runBuild "${APP_NAME}:${APP_VERSION}-php56"
        ;;
    'pure-build-56-coverage')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php56xdebug"
        ;;
    'build-56-coverage')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php56xdebug"
        runBuild "${APP_NAME}:${APP_VERSION}-php56xdebug"
        ;;
    'run-56')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php56"
        runInBackground "${APP_NAME}:${APP_VERSION}-php56"
        ;;
    'run-56-coverage')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php56xdebug"
        runInBackground "${APP_NAME}:${APP_VERSION}-php56xdebug"
        ;;
    'pure-build-71' | 'pure-build')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php71"
        ;;
    'build' | 'build-71')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php71"
        runBuild "${APP_NAME}:${APP_VERSION}-php71"
        ;;
    'pure-build-71-coverage' | 'pure-build-coverage')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php71xdebug"
        ;;
    'build-coverage' | 'build-71-coverage')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php71xdebug"
        runBuild "${APP_NAME}:${APP_VERSION}-php71xdebug"
        ;;
    'run' | 'run-71')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php71"
        runInBackground "${APP_NAME}:${APP_VERSION}-php71"
        ;;
    'run-coverage' | 'run-71-coverage')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php71xdebug"
        runInBackground "${APP_NAME}:${APP_VERSION}-php71xdebug"
        ;;
    'build-7')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php7"
        runBuild "${APP_NAME}:${APP_VERSION}-php7"
        ;;
    'pure-build-7')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php7"
        ;;
    'build-7-coverage')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php7xdebug"
        runBuild "${APP_NAME}:${APP_VERSION}-php7xdebug"
        ;;
    'pure-build-7-coverage')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php7xdebug"
        ;;
    'run-7')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php7"
        runInBackground "${APP_NAME}:${APP_VERSION}-php7"
        ;;
    'run-7-coverage')
        buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php7xdebug"
        runInBackground "${APP_NAME}:${APP_VERSION}-php7xdebug"
        ;;
esac

echo -e "Script finished with exit code: ${BUILD_STATUS}";

exit $BUILD_STATUS;
