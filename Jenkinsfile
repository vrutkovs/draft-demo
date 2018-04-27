node {
  stage("Reconfigure the namespace") {
    checkout scm
    sh "oc replace -f config/fedora-imagestream.yaml"
    sh "oc replace -f config/imagestream.yaml"
    sh "oc replace -f config/buildconfig.yaml"
    sh "oc replace -f config/deploymentconfig.yaml"
    sh "oc apply -f config/service.yaml"
    sh "oc replace -f config/deploymentconfig-tested.yaml"
    sh "oc apply -f config/service-tested.yaml"
    sh "oc replace -f config/route.yaml"
  }

  stage("Build") {
      openshiftBuild buildConfig: "pipeline-app", showBuildLogs: "true"
  }

  stage("Deploy to dev") {
      openshiftDeploy deploymentConfig: "pipeline-app"
  }

  stage("Smoketest") {
    def prefix = "http://pipeline-app.pipelines.svc:8080"

    sh "curl -kLvs ${prefix}/ | grep 'Hello, Anonymous'"
    sh "curl -kLvs ${prefix}/containers | grep 'Hello, containers'"
    sh "curl -kLvs ${prefix}/Vienna | grep 'Hello, Vienna'"
  }

  stage("Deploy to tested") {
      openshiftTag srcStream: "pipeline-app", srcTag: 'latest', destinationStream: "pipeline-app", destinationTag: "smoketested"
      openshiftDeploy deploymentConfig: "pipeline-app-tested"
  }
}
