#!/bin/bash
set -x

. ./envVar.sh
export ORG=$1
export CC_NAME=$2
export CC_VERSION=$3
export SEQUENCE=$4


setGlobals $ORG peer0
# PEER0_PORT=$PORT

# setGlobals $ORG peer1
# PEER1_PORT=$PORT

# setGlobals $ORG peer0

peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION}  --collections-config $PRIVATE_DATA_CONFIG --sequence ${SEQUENCE} --output json 
sleep 1

getAllPeerWithCerts

peer lifecycle chaincode commit -o ${ORDERER_ADDRESS}:${ORDERER_PORT} --ordererTLSHostnameOverride ${ORDERER_ADDRESS} --tls  --collections-config $PRIVATE_DATA_CONFIG --cafile "$ORDERER_CA" --channelID $CHANNEL_NAME --name ${CC_NAME} ${ADDR_COMBINED} --version ${CC_VERSION} --sequence ${SEQUENCE}


# peer lifecycle chaincode commit -o ${ORDERER_ADDRESS}:${ORDERER_PORT} --ordererTLSHostnameOverride ${ORDERER_ADDRESS} --tls --cafile "$ORDERER_CA" --channelID $CHANNEL_NAME --name ${CC_NAME} --peerAddresses peer0.${ORG}.osqo.com:${PEER0_PORT} --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/tlsca/tlsca.${ORG}.osqo.com-cert.pem" --peerAddresses peer1.${ORG}.osqo.com:${PEER1_PORT} --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/tlsca/tlsca.${ORG}.osqo.com-cert.pem" --version ${CC_VERSION} --sequence ${SEQUENCE}



# peer lifecycle chaincode commit -o ${ORDERER_ADDRESS}:${ORDERER_PORT} --ordererTLSHostnameOverride ${ORDERER_ADDRESS} --tls --cafile "$ORDERER_CA" --channelID $CHANNEL_NAME --name ${CC_NAME} --peerAddresses peer0.osqo.osqo.com:6051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/osqo.osqo.com/tlsca/tlsca.osqo.osqo.com-cert.pem" --peerAddresses peer1.osqo.osqo.com:7051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/osqo.osqo.com/tlsca/tlsca.osqo.osqo.com-cert.pem" --peerAddresses peer0.bcp.osqo.com:8051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/bcp.osqo.com/tlsca/tlsca.bcp.osqo.com-cert.pem" --peerAddresses peer1.bcp.osqo.com:9051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/bcp.osqo.com/tlsca/tlsca.bcp.osqo.com-cert.pem" --peerAddresses peer0.esp.osqo.com:1051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/esp.osqo.com/tlsca/tlsca.esp.osqo.com-cert.pem" --peerAddresses peer1.esp.osqo.com:1151 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/esp.osqo.com/tlsca/tlsca.esp.osqo.com-cert.pem" --peerAddresses peer0.broker.osqo.com:1251 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/broker.osqo.com/tlsca/tlsca.broker.osqo.com-cert.pem" --peerAddresses peer1.broker.osqo.com:1351 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/broker.osqo.com/tlsca/tlsca.broker.osqo.com-cert.pem" --version ${CC_VERSION} --sequence ${SEQUENCE}

# peer lifecycle chaincode commit -o orderer.ordererlink.com:7050 --ordererTLSHostnameOverride orderer.ordererlink.com --tls --cafile /home/prashant/mediledger/scripts/../organizations/ordererOrganizations/ordererlink.com/tlsca/tlsca.ordererlink.com-cert.pem --channelID druglink --name insureChain --peerAddresses peer0.unitedhealthgroup.com:1251 --tlsRootCertFiles /home/prashant/mediledger/scripts/../organizations/peerOrganizations/unitedhealthgroup.com/tlsca/tlsca.unitedhealthgroup.com-cert.pem --peerAddresses peer1.unitedhealthgroup.com:1351 --tlsRootCertFiles /home/prashant/mediledger/scripts/../organizations/peerOrganizations/unitedhealthgroup.com/tlsca/tlsca.unitedhealthgroup.com-cert.pem --version 1.0 --sequence 1



sleep 2

peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}
