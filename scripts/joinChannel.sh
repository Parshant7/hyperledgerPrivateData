#!/bin/bash
set -x

. envVar.sh


function setAnchorPeer(){
    
    ORG=$1

    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../../organizations/peerOrganizations/${ORG}.osqo.com/tlsca/tlsca.${ORG}.osqo.com-cert.pem
    echo $CORE_PEER_TLS_ROOTCERT_FILE
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../../organizations/peerOrganizations/${ORG}.osqo.com/users/Admin@${ORG}.osqo.com/msp
    export ORDERER_CA=${PWD}/../../organizations/ordererOrganizations/${ORDERER_ORG}.osqo.com/tlsca/tlsca.${ORDERER_ORG}.osqo.com-cert.pem

    ORDERER_HOST=orderer.${ORDERER_ORG}.osqo.com:${ORDERER_PORT}
    sleep 1
    peer channel fetch config config_block.pb -o ${ORDERER_HOST} --ordererTLSHostnameOverride orderer.${ORDERER_ORG}.osqo.com -c ${CHANNEL_NAME} --tls --cafile "$ORDERER_CA"

    sleep 2

    configtxlator proto_decode --input config_block.pb --type common.Block --output config_block.json
    jq .data.data[0].payload.data.config config_block.json >"${CORE_PEER_LOCALMSPID}config.json"
    
    HOST="peer0.${ORG}.osqo.com"
    
    jq '.channel_group.groups.Application.groups.'${CORE_PEER_LOCALMSPID}'.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "'$HOST'","port": '$PORT'}]},"version": "0"}}' ${CORE_PEER_LOCALMSPID}config.json > ${CORE_PEER_LOCALMSPID}modified_config.json

    configtxlator proto_encode --input "${ORG}MSPconfig.json" --type common.Config --output original_config.pb
    configtxlator proto_encode --input "${ORG}MSPmodified_config.json" --type common.Config --output modified_config.pb
    configtxlator compute_update --channel_id "${CHANNEL_NAME}" --original original_config.pb --updated modified_config.pb --output config_update.pb
    configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate --output config_update.json
    echo '{"payload":{"header":{"channel_header":{"channel_id":"'${CHANNEL_NAME}'", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . >config_update_in_envelope.json
    configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope --output "${ORG}MSPanchor.tx"
    peer channel update -o ${ORDERER_HOST} --ordererTLSHostnameOverride orderer.${ORDERER_ORG}.osqo.com -c $CHANNEL_NAME -f ${CORE_PEER_LOCALMSPID}anchor.tx --tls --cafile "$ORDERER_CA" # >&log.txt

}


ORG=$1

#--------------Join the peers to the channel-------------

setGlobals ${ORG} peer0
peer channel join -b ${BLOCKFILE}

setGlobals ${ORG} peer1
peer channel join -b ${BLOCKFILE}


#--------------set anchor peers-------------
mkdir channel-artifacts
cd channel-artifacts

setGlobals ${ORG} peer0
setAnchorPeer $ORG 
