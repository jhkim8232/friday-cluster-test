#!/bin/bash

rm -rf hdac-node-descs/*
for i in $(seq 1 $1)
do
    cat hdac-node-template.yaml | sed -e "s/{NO}/$i/g" > hdac-node-descs/hdac-node$i.yaml
done
