#!/bin/bash

SRC="$GOPATH/src/friday"

ps -ef | grep grpc | while read line
do
    if [[ $line == *"CasperLabs"* ]];then
        target=$(echo $line |  awk -F' ' '{print $2}')
        kill -9 $target
    fi
done

ps -ef | grep nodef | while read line
do
    if [[ $line == *"nodef"* ]];then
        target=$(echo $line |  awk -F' ' '{print $2}')
        kill -9 $target
    fi
done

# run execution engine grpc server
$SRC/CasperLabs/execution-engine/target/release/casperlabs-engine-grpc-server -t 8 $HOME/.casperlabs/.casper-node.sock&

mkdir -p $HOME/node-config
cp -rf $HOME/node-config/.nodef $HOME/
cp -rf $HOME/node-config/.clif $HOME/

WALLET_ADDRESS=$(clif keys show node1 -a)
NODE_PUB_KEY=$(nodef tendermint show-validator)
NODE_ID=$(nodef tendermint show-node-id)
curl -X PUT $COUCHDB/wallet-address/$WALLET_ADDRESS -d "{\"type\":\"seed-node\",\"node-pub-key\":\"$NODE_PUB_KEY\",\"node-id\":\"$NODE_ID\"}"

nodef start > nodef.txt
