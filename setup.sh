#!/bin/bash
set -eux

oc new-project pipelines || true

# imagestreams
oc replace --force -f config/fedora-imagestream.yaml
oc replace --force -f config/imagestream.yaml

# untested
oc replace --force -f config/buildconfig.yaml
oc replace --force -f config/deploymentconfig.yaml
oc replace --force -f config/service.yaml

# smoketested
oc replace --force -f config/deploymentconfig-tested.yaml
oc replace --force -f config/service-tested.yaml
oc replace --force -f config/route.yaml

# Jenkinsfile
oc new-build --name=pipeline https://github.com/vrutkovs/openshift-demo\#jenkins --strategy pipeline
