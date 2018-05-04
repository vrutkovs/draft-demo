oc new-project pydays-demo
oc new-app --name=hello .
oc expose svc/hello --hostname pydays-demo.e8ca.engint.openshiftapps.com
