#!/usr/bin/env bash

function configuration_project_name()
{
    echo -e "\e[1;31mSet project name: \e[0m"
    read PROJECT_NAME
}

function configuration_web_dir()
{
    echo -e "\e[1;31mSet web directory: \e[0m"
    read WEB_DIR
}

function configuration_project_index_file()
{
    echo -e "\e[1;31mSet project index file: \e[0m"
    read PROJECT_INDEX_FILE
}

function configuration_project_dev_index_file()
{
    echo -e "\e[1;31mSet project dev index file: \e[0m"
    read PROJECT_DEV_INDEX_FILE
}

function confirmation()
{
    echo -e "\e[1;31mDo you confirm below settings: \e[0m"
    echo -e "\e[1;31mProject name: \e[0m${PROJECT_NAME}"
    echo -e "\e[1;31mWeb dir: \e[0m${WEB_DIR}"
    echo -e "\e[1;31mProject index file: \e[0m${PROJECT_INDEX_FILE}"
    echo -e "\e[1;31mProject dev index file: \e[0m${PROJECT_DEV_INDEX_FILE}"
    echo -e "\e[1;31m(y | n)\e[0m"
    read CONFIRMATION
    if [ "${CONFIRMATION}" != 'n' ]; then
        return 1;
    fi

    return 0;
}

function set_configuration()
{
    echo "${PROJECT_NAME}" > ./.project_name
    sed -i "s|PROJECT_WEB_DIR:=\"web\"|PROJECT_WEB_DIR:=\"${WEB_DIR}\"|" docker.sh
    sed -i "s|PROJECT_INDEX_FILE:=\"index.php\"|PROJECT_INDEX_FILE:=\"${PROJECT_INDEX_FILE}\"|" docker.sh
    sed -i "s|PROJECT_DEV_INDEX_FILE:=\"index_dev.php\"|PROJECT_DEV_INDEX_FILE:=\"${PROJECT_DEV_INDEX_FILE}\"|" docker.sh
}

CONFIRMATION='n'
while [ 'n' == $CONFIRMATION ]; do
    configuration_project_name
    configuration_web_dir
    configuration_project_index_file
    configuration_project_dev_index_file
    confirmation
done
