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

### DESCRIPTION OF `docker.sh` USAGE.

```
./docker.sh build ${PROJECT_PHP_VERSION} ${PROJECT_WITH_COVERAGE} 
# usage examples
./docker.sh build 56 true
./docker.sh build 71 false
./docker.sh run 71 false
```

<table>
    <thead>
        <td>Syntax</td>
        <td>Description</td>
    </thead>
    <tbody>
        <tr>
            <td>
                <code>images</code>
            </td>
            <td>
                Build docker images.<br>
                Image versioning is based on <code>version</code> from <code>composer.json</code>
            </td>
        </tr>
        <tr>
            <td>
                <code>run ${PROJECT_PHP_VERSION} ${PROJECT_WITH_COVERAGE}</code>
            </td>
            <td>
                Running local dev env.<br>
                Domain is set based on <code>.composer.json</code> <code>name</code> property without <code>/</code> sign, by default <code>http://pgsdemo.dev:8000</code>
            </td>
        </tr>
        <tr>
            <td>
                <code>build ${PROJECT_PHP_VERSION} ${PROJECT_WITH_COVERAGE}</code>
            </td>
            <td>
                Running local dev env.<br>
                Domain is set based on <code>.composer.json</code> <code>name</code> property without <code>/</code> sign, by default <code>http://pgsdemo.dev:8000</code>
            </td>
        </tr>
    </tbody>
</table>


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

# Authors
 - [Michal Kruczek](https://github.com/partikus/) - <mkruczek@pgs-soft.com>

# Contributors
 - Jan Hryniuk <jhryniuk@pgs-soft.com>

# Contributing

Please read more about [Github Flow](https://guides.github.com/introduction/flow/).

### Docker for Mac

Due to OSx's file sync is extremaly slow we suggest to use [docker-machine-nfs](https://github.com/adlogix/docker-machine-nfs) or [docker-sync.io](http://docker-sync.io/)
