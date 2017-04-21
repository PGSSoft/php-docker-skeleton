#!/usr/bin/env bash

PROJECT_TASK_NAME=$1;
PROJECT_PHP_VERSION=${2:-71};
PROJECT_WITH_COVERAGE=${3:-false};

export APP_NAME=$(echo $(cat composer.json | grep name | head -1 | awk -F: '{ print $2 }' | sed 's/[",\r]//g' | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]'))
export APP_VERSION=$(echo $(cat composer.json | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[",\r]//g'))
export PROJECT_NAME="$APP_NAME"
export PROJECT_WEB_DIR=${PROJECT_WEB_DIR:="web"}
export PROJECT_INDEX_FILE=${PROJECT_INDEX_FILE:="index.php"}
export PROJECT_DEV_INDEX_FILE=${PROJECT_DEV_INDEX_FILE:="index_dev.php"}

USERID=$(id -u);
echo "User ID: $USERID";
echo -e "\nIMAGE VERSION: $APP_NAME:$APP_VERSION\n";
declare -i BUILD_STATUS=0;

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${__DIR}"


FILES=(
    'buildImages.sh'
    'checkContainerExists.sh'
    'defineVariables.sh'
    'runBuild.sh'
    'runInBackground.sh'
)


for FILE in "${FILES[@]}" ; do
    source "bash/${FILE}"
done


echo -e "All defined variables:\n"
( set -o posix ; set ) | grep 'PROJECT|APP'

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

    imageExists "${NAME}:${VERSION}-php56xdebug"
    if [[ $? == 0 ]] && [[ "$PHP" == "php56xdebug" || "$PHP" == "all" ]]; then
        docker build -t "${NAME}:${VERSION}-php56xdebug" --build-arg "USERID=$USERID" docker/php56xdebug
    fi

    imageExists "${NAME}:${VERSION}-php70xdebug"
    if [[ $? == 0 ]] && [[ "$PHP" == "php70xdebug" || "$PHP" == "all" ]]; then
        docker build -t "${NAME}:${VERSION}-php70xdebug" --build-arg "USERID=$USERID" docker/php70xdebug
    fi

    imageExists "${NAME}:${VERSION}-php71xdebug"
    if [[ $? == 0 ]] && [[ "$PHP" == "php71xdebug" || "$PHP" == "all" ]]; then
        docker build -t "${NAME}:${VERSION}-php71xdebug" --build-arg "USERID=$USERID" docker/php71xdebug
    fi

    imageExists "${NAME}:${VERSION}-nginx"
    if [[ $? == 0 ]]; then
        docker build -t "${NAME}:${VERSION}-nginx" docker/nginx
    fi
}

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

if [[ $PROJECT_TASK_NAME == '' ]]; then
    echo -e "Available tasks:";
    echo -e "'./docker.sh build ${PROJECT_PHP_VERSION} ${PROJECT_WITH_COVERAGE}'";
    echo -e "'./docker.sh run ${PROJECT_PHP_VERSION} ${PROJECT_WITH_COVERAGE}' is running dev env with php5.6, xdebug and attaching tty";
    exit 0;
fi

if [ "$PROJECT_TASK_NAME" != "build" ] && [ "$PROJECT_TASK_NAME" != "run" ] && [ "$PROJECT_TASK_NAME" != "images" ]; then
    echo -e "Given task: \"${PROJECT_TASK_NAME}\" is not supported. Choose one of: [images, build, run]."
    exit
fi

if [ "$PROJECT_PHP_VERSION" != "56" ] && [ "$PROJECT_PHP_VERSION" != "70" ] && [ "$PROJECT_PHP_VERSION" != "71" ]; then
    echo -e "Given PHP version: \"${PROJECT_PHP_VERSION}\" is not supported. Choose one of: [56, 70, 71]."
    exit
fi

if [ $PROJECT_WITH_COVERAGE != true ] && [ $PROJECT_WITH_COVERAGE != false ]; then
    echo -e "Given coverage flag: \"${PROJECT_WITH_COVERAGE}\" is not supported. true/false are supported."
    exit
fi

if [[ $PROJECT_TASK_NAME == 'images' ]]; then
    buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "all"
fi

if [[ $PROJECT_TASK_NAME == 'build' ]]; then
    buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php${PROJECT_PHP_VERSION}xdebug"
    runBuild "${APP_NAME}:${APP_VERSION}-php${PROJECT_PHP_VERSION}xdebug" $PROJECT_WITH_COVERAGE
fi

if [[ $PROJECT_TASK_NAME == 'run' ]]; then
    buildImages "${APP_NAME}" "${APP_VERSION}" "${USERID}" "php${PROJECT_PHP_VERSION}xdebug"
    runInBackground "${APP_NAME}:${APP_VERSION}-php${PROJECT_PHP_VERSION}xdebug" $PROJECT_WITH_COVERAGE
fi

echo -e "Script finished with exit code: ${BUILD_STATUS}";

exit $BUILD_STATUS;
