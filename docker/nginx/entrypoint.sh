#!/bin/bash

# Using environment variables to set nginx configuration
[ -z "${PROJECT_NAME}" ] && echo "\$PROJECT_NAME is not set" || sed -i "s/PROJECT_NAME/${PROJECT_NAME}/" /etc/nginx/conf.d/default.conf
[ -z "${PROJECT_WEB_DIR}" ] && echo "\$PROJECT_WEB_DIR is not set" || sed -i "s/PROJECT_WEB_DIR/${PROJECT_WEB_DIR}/" /etc/nginx/conf.d/default.conf
[ -z "${PROJECT_INDEX_FILE}" ] && echo "\$PROJECT_INDEX_FILE is not set" || sed -i "s/PROJECT_INDEX_FILE/${PROJECT_INDEX_FILE}/" /etc/nginx/conf.d/default.conf
[ -z "${PROJECT_DEV_INDEX_FILE}" ] && echo "\$PROJECT_DEV_INDEX_FILE is not set" || sed -i "s/PROJECT_DEV_INDEX_FILE/${PROJECT_DEV_INDEX_FILE}/" /etc/nginx/conf.d/default.conf


# Start nginx
/usr/sbin/nginx -g "daemon off;"
