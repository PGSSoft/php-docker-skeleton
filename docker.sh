#!/usr/bin/env bash

PROJECT_TASK_NAME=$1;
PROJECT_PHP_VERSION=${2:-71};
PROJECT_WITH_COVERAGE=${3:-false};

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${__DIR}"

FILES=(
    'buildImages.sh'
    'checkImageExists.sh'
    'defineVariables.sh'
    'runBuild.sh'
    'runInBackground.sh'
)

for FILE in "${FILES[@]}" ; do
    source "bash/${FILE}"
done

defineVariables

echo -e "All defined variables:\n"
( set -o posix ; set ) | grep 'PROJECT|APP'

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
