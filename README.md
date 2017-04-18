# Docker PHP skeleton

[![npm](https://img.shields.io/badge/nginx-1.10-brightgreen.svg)]()
[![npm](https://img.shields.io/badge/node-4.2-brightgreen.svg)]()
[![npm](https://img.shields.io/badge/php-5.6-brightgreen.svg)]()
[![npm](https://img.shields.io/badge/php-7.0-brightgreen.svg)]()
[![npm](https://img.shields.io/badge/php-7.1-brightgreen.svg)]()
[![npm](https://img.shields.io/badge/mysql-5.7-brightgreen.svg)]()

Maintainer: [Michal Kruczek](https://github.com/partikus)

This stack uses: [nginx](https://hub.docker.com/_/nginx/) (lastest), [php-fpm](https://hub.docker.com/_/php/) (5.6, 7.1, 7.0), [mysql](https://hub.docker.com/_/mysql/) (5.7).

This skeleton can be used to developing app locally or to running tests in Jenkins etc.

1. Build docker images running ``./docker.sh build-images``. Image versioning is based on `version` from `composer.json`
2. Running local dev env: ``./docker.sh run`` Domain is set based on ``.project_name``, by default ``http://demo.dev:8000``
3. Running tests on PHP 7.1: ``./docker.sh build``
4. Running tests on PHP 7.1 with CodeCoverage(include xdebug): ``./docker.sh build-coverage``
5. Running tests on PHP 7.0: ``./docker.sh build-7``
6. Running tests on PHP 7.0 with CodeCoverage(include xdebug): ``./docker.sh build-coverage-7``
7. Running tests on PHP 5.6: ``./docker.sh build-56``


## Getting started

In order to add docker skeleton to your project follow the steps below:

1. Clone skeleton from github repository `git clone git@github.com:PGSSoft/php-docker-skeleton.git`
2. Copy below files from `php-docker-skeleton` folder to your main project folder:

```
.
├── docker
│   ├── nginx
│   │   ├── Dockerfile
│   │   ├── entrypoint.sh
│   │   └── php.conf
│   ├── php56
│   │   ├── Dockerfile
│   │   ├── entrypoint.sh
│   │   └── php.ini
│   ├── php56xdebug
│   │   ├── Dockerfile
│   │   ├── docker-php-pecl-install
│   │   ├── entrypoint.sh
│   │   └── php.ini
│   ├── php7
│   │   ├── Dockerfile
│   │   ├── entrypoint.sh
│   │   └── php.ini
│   ├── php71
│   │   ├── Dockerfile
│   │   ├── entrypoint.sh
│   │   └── php.ini
│   ├── php71xdebug
│   │   ├── Dockerfile
│   │   ├── docker-php-pecl-install
│   │   ├── entrypoint.sh
│   │   └── php.ini
│   └── php7xdebug
│       ├── Dockerfile
│       ├── docker-php-pecl-install
│       ├── entrypoint.sh
│       └── php.ini
├── .project_name
├── docker-compose.local.yml
├── docker-compose.yml
└── docker.sh
```

3. Set project name inside file `.project_name`
4. Customize below lines inside `docker.sh` script:
```
export PROJECT_WEB_DIR=${PROJECT_WEB_DIR:="web"} # Project doc_root directory.
export PROJECT_INDEX_FILE=${PROJECT_INDEX_FILE:="index.php"} # Project main index file.
export PROJECT_DEV_INDEX_FILE=${PROJECT_DEV_INDEX_FILE:="index_dev.php"} # Project dev index file.
```

5. After that configuration you should be able to run `./docker.sh build-images`

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
