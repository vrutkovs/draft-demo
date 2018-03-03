try {
   timeout(time: 20, unit: 'MINUTES') {
      def tag="blue"
      def altTag="green"

      node {
        stage("Initialize") {
          sh "oc get route blue-green -n blue-green -o jsonpath='{ .spec.to.name }' --loglevel=4 > activeservice"
          activeService = readFile('activeservice').trim()
          if (activeService == "blue") {
            tag = "green"
            altTag = "blue"
          }
          sh "oc get route blue-green -n blue-green-o jsonpath='{ .spec.host }' --loglevel=4 > routehost"
          routeHost = readFile('routehost').trim()
        }

        stage("Build") {
          echo "building tag ${tag}"
          openshiftBuild buildConfig: "pipeline-app", showBuildLogs: "true", verbose: "true"
        }

        stage("Deploy Test") {
          openshiftTag srcStream: "pipeline-app", srcTag: 'latest', destinationStream: "pipeline-app", destinationTag: tag, "true": "true"
          openshiftVerifyDeployment deploymentConfig: "${tag}", verbose: "true"
        }

        stage("Automated tests") {
          sh "curl -kLvs http://${routeHost}/ | grep 'Hello, Anonymous'"
          sh "curl -kLvs http://${routeHost}/containers | grep 'Hello, containers'"
          sh "curl -kLvs http://${routeHost}/Питер | grep 'Hello, Питер'"
        }

        stage("Manual test and approve") {
          input message: "Test deployment: http://${routeHost}. Approve?", id: "approval"
        }

        stage("Go Live") {
          sh "oc set -n blue-green route-backends prod-route ${tag}=100 ${altTag}=0 --loglevel=4"

          // Canary deployment
          // sh "oc set -n blue-green route-backends pipeline-app ${tag}=10 ${altTag}=90 --loglevel=4"
          // input message: "10% deployment on http://${routeHost}. Approve?", id: "approval"
        }
      }
   }
} catch (err) {
   echo "in catch block"
   echo "Caught: ${err}"
   currentBuild.result = 'FAILURE'
   throw err
}
