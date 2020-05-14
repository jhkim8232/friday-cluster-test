This repository provides you with the convenient way to make the test evnvironment for friday easiy. 

Prerequsite
1. Install aws-cli
2. Install kubectl

Procedure
1. Run "./kops/make-cluster.sh create", which is for creating the k8s nodes. If you want, you can edit the script.
2. Run "./kubefiles/make-hdac-node-desc.sh {NO}", which {NO} means the number of hdac-nodes except seed node. 
2. Run "./kubefiles/deploy-node.sh"
