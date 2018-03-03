#!/bin/bash
set -eux

oc new-project blue-green || true

# imagestreams
oc replace --force -f config/fedora-imagestream.yaml
oc replace --force -f config/imagestream.yaml
oc replace --force -f config/buildconfig.yaml

# blue
oc replace --force -f config/blue-deploymentconfig.yaml
oc replace --force -f config/blue-service.yaml

# green
oc replace --force -f config/green-deploymentconfig.yaml
oc replace --force -f config/green-service.yaml

oc replace --force -f config/route.yaml
