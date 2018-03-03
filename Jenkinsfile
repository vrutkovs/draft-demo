node {
  stage("Build") {
      openshiftBuild buildConfig: "pipeline-app", showBuildLogs: "true"
  }

  stage("Deploy to dev") {
      openshiftDeploy deploymentConfig: "pipeline-app"
  }

  stage("Smoketest") {
      sh "curl -kLvs http://pipeline-app.pipelines.svc:8080/containers | grep 'Hello, containers'"
  }

  stage("Deploy to tested") {
      openshiftTag srcStream: "pipeline-app", srcTag: 'latest', destinationStream: "pipeline-app", destinationTag: "smoketested"
      openshiftDeploy deploymentConfig: "pipeline-smoketested"
  }
}

