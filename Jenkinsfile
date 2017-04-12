#!/usr/bin/env groovy

def maintenance
def runner
def label = ""
def env = "dev"

node(label) {
    checkout([$class: 'GitSCM', branches: [[name: 'feature/add-jenkinsfile']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/jhryniuk/php-docker-skeleton']]])
    maintenance = load 'jenkins/maintenance.groovy'
    //runner = load 'jenkins/runner.groovy'
}

maintenance.maintenance(label)

//runner.runInParallel(label, env, maintenance.&maintenance)
