#!/bin/bassh
set -x
git yolo
git push origin -f
oc start-build openshift-demo -w
