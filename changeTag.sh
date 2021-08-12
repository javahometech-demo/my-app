#!/bin/bash
sed "s/tagVersion/$1/g" k8s/deployment.yml > deployment1.yaml
cat k8s/services.yml > services.yml
