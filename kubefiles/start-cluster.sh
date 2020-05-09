#!/bin/bash

COUCHDB="http://admin:admin@13.125.228.37:5984"

curl -X PUT $COUCHDB/wallet-address
kubectl create -f friday-namespace.yaml
kubectl create configmap node-config --from-file=node-config -n=fct
