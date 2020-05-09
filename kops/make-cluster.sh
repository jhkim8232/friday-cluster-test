#!/bin/bash

export KOPS_STATE_STORE="s3://friday-cluster-test"
export NAME="friday.k8s.local"    # DNS가 설정되어 있지 않은 경우
export INSTANCE_TYPE="m5.xlarge"
export IMAGE="ami-01183f93ce9c0e25d"
export REGION="ap-northeast-2"
export ZONE="ap-northeast-2a"
export PUBKEY="./keys/friday-cluster-test.pub"

if [ $# -eq 0 ];then
	echo "input create, update or delete"
	exit 0 
fi

if [ $1 == "create" ];then
	kops create cluster --kubernetes-version=1.12.1 \
	    --ssh-public-key $PUBKEY \
	    --networking flannel \
	    --api-loadbalancer-type public \
	    --admin-access 0.0.0.0/0 \
	    --authorization RBAC \
	    --zones $ZONE \
	    --master-zones $ZONE \
	    --master-size $INSTANCE_TYPE \
	    --node-size $INSTANCE_TYPE \
	    --master-volume-size 200 \
	    --node-volume-size 200 \
	    --node-count 4 \
	    --cloud aws \
	    --name $NAME \
	    --yes
fi

if [ $1 == "delete" ];then
	kops delete cluster --name=$NAME --state=$KOPS_STATE_STORE --yes
fi

if [ $1 == "update" ];then
	kops update cluster ${NAME} --yes
fi
