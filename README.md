# Docker PHP skeleton

[![npm](https://img.shields.io/badge/nginx-1.10-brightgreen.svg)]()
[![npm](https://img.shields.io/badge/node-4.2-brightgreen.svg)]()
[![npm](https://img.shields.io/badge/php-5.6-brightgreen.svg)]()
[![npm](https://img.shields.io/badge/php-7.0-brightgreen.svg)]()
[![npm](https://img.shields.io/badge/mysql-5.7-brightgreen.svg)]()

Maintainer: [Michal Kruczek](https://github.com/partikus)

This stack uses: [nginx](https://hub.docker.com/_/nginx/) (lastest), [php-fpm](https://hub.docker.com/_/php/) (5.6, 7.0), [mysql](https://hub.docker.com/_/mysql/) (5.7).

This skeleton can be used to developing app locally or to running tests in Jenkins etc.

1. Build docker images running ``./docker.sh build-images``
2. Running local dev env: ``./docker.sh run`` Domain is set based on ``.project_name``, by default ``http://demo.dev:8000``
3. Running tests on PHP 7.0: ``./docker.sh build``
4. Running tests on PHP 7.0 with CodeCoverage(include xdebug): ``./docker.sh build-coverage``
5. Running tests on PHP 5.6: ``./docker.sh build-56``

## Enjoy!

Authors
-------
 - [Michal Kruczek](https://github.com/partikus/) - <mkruczek@pgs-soft.com>

Contributors
------------
 - Jan Hryniuk <jhryniuk@pgs-soft.com>

Contributing
------------
Please read more about [Github Flow](https://guides.github.com/introduction/flow/).
