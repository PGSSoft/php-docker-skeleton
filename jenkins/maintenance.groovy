def maintenance(label) {

    node(label) {
        try {
            stage('Build') {
                echo 'Building..'
                echo "./docker.sh build-images"
            }

            stage('Running Selenium') {
                sh "./docker.sh run-tests"
            }

        } catch (e) {
            currentBuild.result = "FAILED"
            throw e
        } finally {
            stage('CleanUp') {
                echo 'Cleaning up...'
            }
        }        
    }
}

return this