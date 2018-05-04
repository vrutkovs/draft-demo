oc new-project demo-master || oc project demo-master
oc new-app --name=hello https://github.com/vrutkovs/openshift-demo
oc expose svc/hello --hostname hello-demo-master.e8ca.engint.openshiftapps.com
