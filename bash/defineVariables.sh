#!/usr/bin/env bash

function defineVariables
{
    export PROJECT_NAME=$(cat ".project_name")
    export PROJECT_XDEBUG_ENABLED=false
    export PROJECT_WEB_DIR=${PROJECT_WEB_DIR:="web"}
    export PROJECT_INDEX_FILE=${PROJECT_INDEX_FILE:="index.php"}
    export PROJECT_DEV_INDEX_FILE=${PROJECT_DEV_INDEX_FILE:="index_dev.php"}
    export APP_NAME=$(echo $(cat "composer.json" | grep name | head -1 | awk -F: '{ print $2 }' | sed 's/[",\r]//g' | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]'))
    export APP_VERSION=$(echo $(cat "composer.json" | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[",\r]//g'))
    export USERID=$(id -u);

    echo "User ID: $USERID";
    echo -e "\nIMAGE VERSION: $APP_NAME:$APP_VERSION\n";
    declare -i BUILD_STATUS=0;
}
