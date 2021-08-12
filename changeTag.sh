#!/bin/bash
sed "s/tagVersion/$1/g" deployment.yml > deployment1.yaml
