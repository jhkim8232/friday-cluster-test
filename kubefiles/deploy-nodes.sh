#!/bin/bash


#delete couchDB
curl -X DELETE http://admin:admin@13.125.228.37:5984/seed-info
curl -X DELETE http://admin:admin@13.125.228.37:5984/wallet-address

#create couchDB
curl -X PUT http://admin:admin@13.125.228.37:5984/seed-info
curl -X PUT http://admin:admin@13.125.228.37:5984/wallet-address

kubectl delete -f ./hdac-node.yaml
kubectl delete -f ./hdac-seed.yaml
kubectl apply -f ./hdac-seed.yaml

stop_flag="0"
while true
do
    res=$(kubectl get pods) 
    if [[ "${res}" == *"hdac-seed"*"Running"* ]];then
        break
    fi
done

kubectl apply -f ./hdac-node.yaml
