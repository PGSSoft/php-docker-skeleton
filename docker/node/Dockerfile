FROM node:4.2

MAINTAINER Michał Kruczek <mkruczek@pgs-soft.com>

COPY package.json /app/package.json
COPY entrypoint.sh /entrypoint.sh

RUN npm cache clear && \
    npm config set registry https://registry.npmjs.org/ && \
    npm install --allow-root -g -d --silent npm@2.14 && \
    npm install --allow-root -g -d --silent bower && \
    npm install --allow-root -g -d --silent gulp && \
    cd /app/ && \
    /usr/local/bin/node --stack-size=64000 /usr/local/bin/npm install --no-bin-links --quiet

WORKDIR /var/www/

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
