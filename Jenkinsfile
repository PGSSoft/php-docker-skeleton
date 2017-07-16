#!/usr/bin/env groovy

def phpVersions() {
    return ['56', '70', '71']
}

def getRunners(debug = false) {
    def phpVersions = phpVersions();
    def runners = [:]

    for (String version : phpVersions) {
        runners["${version}"] = {
            checkout scm
            sh "./docker.sh build ${version} ${debug}"
        }
    }

    return runners
}

node('docker') {
    ansiColor('xterm') {
        stage('Checkout') {
            checkout scm
        }

        stage('Build Images') {
            sh './docker.sh images'
        }

        stage('Build') {
            parallel getRunners(false)
        }

        stage('Build with xDebug') {
            parallel getRunners(true)
        }
    }
}
