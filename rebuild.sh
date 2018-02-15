#!/bin/bash
set -x
git yolo
git push origin -f
oc start-build openshift-demo -F
