#!/bin/bash
set -x
. ./envVar.sh

export ORG=$1
export CC_NAME=$2
export CC_SRC_PATH=$3
export CC_VERSION=$4
export SEQUENCE=$5
export CC_RUNTIME_LANGUAGE=node


peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION} 

export PACKAGE_ID=$(peer lifecycle chaincode calculatepackageid ${CC_NAME}.tar.gz)


setGlobals ${ORG} peer0

peer lifecycle chaincode queryinstalled --output json | jq -r 'try (.installed_chaincodes[].package_id)' | grep ^${PACKAGE_ID}$ 
peer lifecycle chaincode install ${CC_NAME}.tar.gz 

sleep 1

setGlobals ${ORG} peer1
 
peer lifecycle chaincode queryinstalled --output json | jq -r 'try (.installed_chaincodes[].package_id)' | grep ^${PACKAGE_ID}$ 
peer lifecycle chaincode install ${CC_NAME}.tar.gz 

sleep 1

peer lifecycle chaincode approveformyorg -o ${ORDERER_ADDRESS}:${ORDERER_PORT} \
 --ordererTLSHostnameOverride ${ORDERER_ADDRESS} \
 --tls --cafile "$ORDERER_CA" \
 --collections-config $PRIVATE_DATA_CONFIG \
 --channelID $CHANNEL_NAME \
 --name ${CC_NAME} \
 --version ${CC_VERSION} \
 --package-id ${PACKAGE_ID} \
 --sequence ${SEQUENCE} \

