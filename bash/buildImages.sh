#!/usr/bin/env bash

function buildImages {
    NAME=$1
    VERSION=$2
    USERID=${3:-1000}
    PHP=${4-:"all"}


    imageExists "${NAME}:${VERSION}-php56xdebug"
    if [[ $? == 0 ]] && [[ "$PHP" == "php56xdebug" || "$PHP" == "all" ]]; then
        docker build -t "${NAME}:${VERSION}-php56xdebug" --build-arg "USERID=$USERID" "docker/php56xdebug"
    fi

    imageExists "${NAME}:${VERSION}-php7xdebug"
    if [[ $? == 0 ]] && [[ "$PHP" == "php7xdebug" || "$PHP" == "all" ]]; then
        docker build -t "${NAME}:${VERSION}-php7xdebug" --build-arg "USERID=$USERID" "docker/php7xdebug"
    fi

    imageExists "${NAME}:${VERSION}-php71xdebug"
    if [[ $? == 0 ]] && [[ "$PHP" == "php71xdebug" || "$PHP" == "all" ]]; then
        docker build -t "${NAME}:${VERSION}-php71xdebug" --build-arg "USERID=$USERID" "docker/php71xdebug"
    fi

    imageExists "${NAME}:${VERSION}-nginx"
    if [[ $? == 0 ]]; then
        docker build -t "${NAME}:${VERSION}-nginx" "docker/nginx"
    fi
}
