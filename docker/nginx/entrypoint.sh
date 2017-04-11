#!/bin/bash

# Using environment variables to set nginx configuration
[ -z "${APP_NAME}" ] && echo "\$APP_NAME is not set" || sed -i "s/APP_NAME/${APP_NAME}/" /etc/nginx/conf.d/default.conf
[ -z "${PROJECT_WEB_DIR}" ] && echo "\$PROJECT_WEB_DIR is not set" || sed -i "s/PROJECT_WEB_DIR/${PROJECT_WEB_DIR}/" /etc/nginx/conf.d/default.conf
[ -z "${PROJECT_INDEX_FILE}" ] && echo "\$PROJECT_INDEX_FILE is not set" || sed -i "s/PROJECT_INDEX_FILE/${PROJECT_INDEX_FILE}/" /etc/nginx/conf.d/default.conf
[ -z "${PROJECT_DEV_INDEX_FILE}" ] && echo "\$PROJECT_DEV_INDEX_FILE is not set" || sed -i "s/PROJECT_DEV_INDEX_FILE/${PROJECT_DEV_INDEX_FILE}/" /etc/nginx/conf.d/default.conf


# Start nginx
/usr/sbin/nginx -g "daemon off;"
