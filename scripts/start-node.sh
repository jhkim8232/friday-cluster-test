#!/bin/bash

COUCHDB="http://admin:admin@13.125.228.37:5984"
SRC="$GOPATH/src/friday"
rm -rf $HOME/.nodef/config
rm -rf $HOME/.nodef/data
rm -rf $HOME/.clif

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

# init node
nodef init testnode --chain-id testnet

# create a wallet key
PW="12345678"

expect -c "
set timeout 3
spawn clif keys add node1
expect "disk:"
    send \"$PW\\r\"
expect "passphrase:"
    send \"$PW\\r\"
expect eof
"

# apply default clif configure
clif config chain-id testnet
clif config output json
clif config indent true
clif config trust-node true

cp -f $GOPATH/src/friday-cluster-test/config/node-config/nodef-config/config/genesis.json $HOME/.nodef/config
cp -f $GOPATH/src/friday-cluster-test/config/node-config/nodef-config/config/manifest.toml $HOME/.nodef/config
#SEED=$(cat $HOME/.nodef/config/genesis.json | jq .app_state.genutil.gentxs[0].value.memo)
SEED=$(curl http://admin:admin@13.125.228.37:5984/seed-info/seed-info | jq .target)
sed -i "s/seeds = \"\"/seeds = $SEED/g" $HOME/.nodef/config/config.toml
sed -i "s/prometheus = false/prometheus = true/g" $HOME/.nodef/config/config.toml

WALLET_ADDRESS=$(clif keys show node1 -a)
NODE_PUB_KEY=$(nodef tendermint show-validator)
NODE_ID=$(nodef tendermint show-node-id)
curl -X PUT $COUCHDB/wallet-address/$WALLET_ADDRESS -d "{\"type\":\"full-node\",\"node-pub-key\":\"$NODE_PUB_KEY\",\"node-id\":\"$NODE_ID\"}"

nodef start > nodef.txt
