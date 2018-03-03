try {
   timeout(time: 20, unit: 'MINUTES') {
      def appName="spblug"
      def project="blue-green"
      def tag="blue"
      def altTag="green"
      def verbose="true"

      node {
        project = env.PROJECT_NAME
        stage("Initialize") {
          sh "oc get route ${appName} -n ${project} -o jsonpath='{ .spec.to.name }' --loglevel=4 > activeservice"
          activeService = readFile('activeservice').trim()
          if (activeService == "${appName}-blue") {
            tag = "green"
            altTag = "blue"
          }
          sh "oc get route ${tag}-${appName} -n ${project} -o jsonpath='{ .spec.host }' --loglevel=4 > routehost"
          routeHost = readFile('routehost').trim()
        }

        stage("Build") {
          echo "building tag ${tag}"
          openshiftBuild buildConfig: appName, showBuildLogs: "true", verbose: verbose
        }

        stage("Deploy Test") {
          openshiftTag srcStream: appName, srcTag: 'latest', destinationStream: appName, destinationTag: tag, verbose: verbose
          openshiftVerifyDeployment deploymentConfig: "${appName}-${tag}", verbose: verbose
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
          sh "oc set -n ${project} route-backends ${appName} ${appName}-${tag}=100 ${appName}-${altTag}=0 --loglevel=4"

          // Canary deployment
          // sh "oc set -n ${project} route-backends ${appName} ${appName}-${tag}=10 ${appName}-${altTag}=90 --loglevel=4"
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
