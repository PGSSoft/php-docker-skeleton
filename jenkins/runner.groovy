def testRunners() {
    def testRunners = [
            "RunUnitTests"
    ]

    return testRunners
}

def prepareRunners(label, appEnv, maintenance, isParallel = false) {
    def predefinedTestRunners = this.testRunners()
    def runners = [:]

    for (String platform : predefinedTestRunners) {
        def p = platform
        runners["${p}"] = {
            maintenance(label, appEnv, p, isParallel)
        }
    }

    return runners
}

def runInParallel(label, appEnv, maintenance) {
    def runners = prepareRunners(label, appEnv, maintenance, true)

    if (runners.size() != 0) {
        parallel runners
    }
}

def runInSequence(label, appEnv, maintenance) {
    def predefinedTestRunners = this.testRunners()

    for (String runner : predefinedTestRunners) {
        def r = runner
        maintenance(label, appEnv, r, false)
    }
}

return this