#!/bin/bash
set -x

. envVar.sh

sleep 2

DOCKER_SOCK=/var/run/docker.sock docker-compose -f ../network-compose/${ORDERER_ORG}.yaml up -d 
sleep 2

function joinOrderer(){

    ORG=$1
    ORDERER_NO=$2
    ORDERER_ADMIN_PORT=$3

    export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/../organizations/ordererOrganizations/${ORG}.osqo.com/orderers/${ORDERER_NO}.${ORG}.osqo.com/tls/server.crt
    export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/../organizations/ordererOrganizations/${ORG}.osqo.com/orderers/${ORDERER_NO}.${ORG}.osqo.com/tls/server.key

    osnadmin channel join --channelID $CHANNEL_NAME --config-block ./genesis-block/${CHANNEL_NAME}.block -o ${ORDERER_NO}.${ORG}.osqo.com:${ORDERER_ADMIN_PORT} --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
}

joinOrderer ordererlink orderer 7053
joinOrderer ordererlink orderer2 8053
joinOrderer ordererlink orderer3 9053
joinOrderer ordererlink orderer4 1053
joinOrderer ordererlink orderer5 1153












# set -x

# export ORDERER_CA=${PWD}/../organizations/ordererOrganizations/ordererlink.com/tlsca/tlsca.ordererlink.com-cert.pem
# export PATH=${PWD}/../bin:$PATH
# export FABRIC_CFG_PATH=${PWD}/../config
# export CHANNEL_NAME=druglink
# export PROFILE_NAME=druglinkGenesis
# export BLOCKFILE="./genesis-block/${CHANNEL_NAME}.block"


# # Creating Conntainer with docker and docker-compose files
# COMPOSE_NETWORK_FILES="-f ../network-compose/fda.yaml -f ../network-compose/ranbaxy.yaml -f ../network-compose/medlineindustries.yaml -f ../network-compose/unitedhealthgroup.yaml -f ../network-compose/ordererlink.yaml -f ../network-compose/cli.yaml"

# DOCKER_SOCK=/var/run/docker.sock docker-compose $COMPOSE_NETWORK_FILES up -d 
# sleep 2

# # Creating Genesis block
# mkdir genesis-block
# configtxgen -profile ${PROFILE_NAME} -outputBlock ${BLOCKFILE} -channelID $CHANNEL_NAME

# sleep 2

# export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/../organizations/ordererOrganizations/ordererlink.com/orderers/orderer.ordererlink.com/tls/server.crt
# export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/../organizations/ordererOrganizations/ordererlink.com/orderers/orderer.ordererlink.com/tls/server.key

# osnadmin channel join --channelID $CHANNEL_NAME --config-block ./genesis-block/${CHANNEL_NAME}.block -o orderer.ordererlink.com:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY" # >&log.txt

# export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/../organizations/ordererOrganizations/ordererlink.com/orderers/orderer2.ordererlink.com/tls/server.crt
# export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/../organizations/ordererOrganizations/ordererlink.com/orderers/orderer2.ordererlink.com/tls/server.key

# osnadmin channel join --channelID $CHANNEL_NAME --config-block ./genesis-block/${CHANNEL_NAME}.block -o orderer2.ordererlink.com:8053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY" # >&log.txt

# export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/../organizations/ordererOrganizations/ordererlink.com/orderers/orderer3.ordererlink.com/tls/server.crt
# export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/../organizations/ordererOrganizations/ordererlink.com/orderers/orderer3.ordererlink.com/tls/server.key
# osnadmin channel join --channelID $CHANNEL_NAME --config-block ./genesis-block/${CHANNEL_NAME}.block -o orderer3.ordererlink.com:9053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY" # >&log.txt

# export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/../organizations/ordererOrganizations/ordererlink.com/orderers/orderer4.ordererlink.com/tls/server.crt
# export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/../organizations/ordererOrganizations/ordererlink.com/orderers/orderer4.ordererlink.com/tls/server.key
# osnadmin channel join --channelID $CHANNEL_NAME --config-block ./genesis-block/${CHANNEL_NAME}.block -o orderer4.ordererlink.com:1053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY" # >&log.txt

# export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/../organizations/ordererOrganizations/ordererlink.com/orderers/orderer5.ordererlink.com/tls/server.crt
# export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/../organizations/ordererOrganizations/ordererlink.com/orderers/orderer5.ordererlink.com/tls/server.key
# osnadmin channel join --channelID $CHANNEL_NAME --config-block ./genesis-block/${CHANNEL_NAME}.block -o orderer5.ordererlink.com:1153 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY" # >&log.txt
