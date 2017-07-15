#!/usr/bin/env bash

function imageExists {
    IMAGE_NAME=$1
    if docker history -q "$IMAGE_NAME" > /dev/null 2>&1; then
        echo - "$IMAGE_NAME already exist"
        return 1;
    fi

    return 0;
}
