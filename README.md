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

### DESCRIPTION OF `docker.sh` ATTRIBUTES.

<table>
    <thead>
        <td>ATTRIBUTE</td>
        <td>DESCRIPTION</td>
    </thead>
    <tbody>
        <tr>
            <td>
                `build-images`
            </td>
            <td>
                Build docker images.<br>
                Image versioning is based on `version` from `composer.json`
            </td>
        </tr>
        <tr>
            <td>
                `run`<br>
                `run-71`
            </td>
            <td>
                Running local dev env.<br>
                Domain is set based on ``.composer.json`` ``name`` property without ``/`` sign, by default ``http://pgsdemo.dev:8000`` PHP 7.1
            </td>
        </tr>
        <tr>
            <td>
                `run-7`
            </td>
            <td>
                Running local dev env.<br>
                Domain is set based on ``.composer.json`` ``name`` property without ``/`` sign, by default ``http://pgsdemo.dev:8000`` PHP 7
            </td>
        </tr>
        <tr>
            <td>
                `run-56`
            </td>
            <td>
                Running local dev env.<br>
                Domain is set based on ``.composer.json`` ``name`` property without ``/`` sign, by default ``http://pgsdemo.dev:8000`` PHP 56
            </td>
        </tr>
        <tr>
            <td>
                `build`<br>
                `build-71`
            </td>
            <td>
                Running tests on PHP 7.1
            </td>
        </tr>
        <tr>
            <td>
                `build-7`
            </td>
            <td>
                Running tests on PHP 7.0
            </td>
        </tr>
        <tr>
            <td>
                `build-56`
            </td>
            <td>
                Running tests on PHP 5.6
            </td>
        </tr>
        <tr>
            <td>
                `build-coverage`<br>
                `build-71-coverage`
            </td>
            <td>
                Running tests on PHP 7.1 with CodeCoverage(include xdebug)
            </td>
        </tr>
        <tr>
            <td>
                `build-7-coverage`
            </td>
            <td>
                Running tests on PHP 7.0 with CodeCoverage(include xdebug)
            </td>
        </tr>
        <tr>
            <td>
                `build-56-coverage`
            </td>
            <td>
                Running tests on PHP 5.6 with CodeCoverage(include xdebug)
            </td>
        </tr>
    </tbody>
</table>


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
