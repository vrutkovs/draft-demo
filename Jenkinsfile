node {
  stage("Build") {
      openshiftBuild buildConfig: "spblug-app", showBuildLogs: "true"
  }

  stage("Deploy to dev") {
      openshiftDeploy deploymentConfig: "spblug-app"
  }

  stage("Smoketest") {
      sh "curl -kLvs http://s2i-dotnetcore-ex:8080/containers | grep 'Hello, containers'"
  }

  stage("Deploy to tested") {
      openshiftTag srcStream: "spblug-app", srcTag: 'latest', destinationStream: "spblug-app", destinationTag: "smoketested"
      openshiftDeploy deploymentConfig: "spblug-smoketested"
  }
}

