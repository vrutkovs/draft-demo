node {
  stage("Reconfigure the namespace") {
    checkout scm
    sh "ls -la"
    sh "ls -la .."
    sh "ls -la ../.."
    sh "oc replace -f config/buildconfig.yaml"
    sh "oc replace -f config/deploymentconfig.yaml"
    sh "oc replace -f config/service.yaml"
    sh "oc replace -f config/deploymentconfig-tested.yaml"
    sh "oc replace -f config/service-tested.yaml"
    sh "oc replace -f config/route.yaml"
  }

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
