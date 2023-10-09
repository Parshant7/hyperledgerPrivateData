#!/bin/bash


ORG1="osqo" 
ORG2="bcp"
ORG3="esp"
ORG4="broker"
ORDERER_ORG="ordererlink"
ORDERER_CA_PORT=1054

export CORE_PEER_TLS_ENABLED=true
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config
export VERBOSE=false

#--------Orderer env----------

export ORDERER_CA=${PWD}/../organizations/ordererOrganizations/${ORDERER_ORG}.osqo.com/tlsca/tlsca.${ORDERER_ORG}.osqo.com-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/../organizations/ordererOrganizations/${ORDERER_ORG}.osqo.com/orderers/orderer.${ORDERER_ORG}.osqo.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/../organizations/ordererOrganizations/${ORDERER_ORG}.osqo.com/orderers/orderer.${ORDERER_ORG}.osqo.com/tls/server.key
export ORDERER_PORT=7050
export ORDERER_ADDRESS="orderer.ordererlink.osqo.com"

#--------Channel Related env----------

export CHANNEL_NAME=druglink
export PROFILE_NAME=druglinkGenesis
export BLOCKFILE="./genesis-block/${CHANNEL_NAME}.block"

#--------Chaincode Related env----------

export PRIVATE_DATA_CONFIG=${PWD}/../chaincode/insurechain/car-config.json

#-------------------------------------


function setGlobals(){

    if [ $1 = "osqo" ]; then
        echo $1 $2
        if [ $2 = "peer0" ]; then
            export PEER0_ORG1_CA=${PWD}/../organizations/peerOrganizations/osqo.osqo.com/tlsca/tlsca.osqo.osqo.com-cert.pem 
            export CORE_PEER_LOCALMSPID="osqoMSP"
            export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
            export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/osqo.osqo.com/users/Admin@osqo.osqo.com/msp
            export CORE_PEER_ADDRESS=peer0.osqo.osqo.com:6051
            export PORT=6051

        elif [ $2 = "peer1" ]; then
            export PEER1_ORG1_CA=${PWD}/../organizations/peerOrganizations/osqo.osqo.com/tlsca/tlsca.osqo.osqo.com-cert.pem 
            export CORE_PEER_LOCALMSPID="osqoMSP"
            export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG1_CA
            export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/osqo.osqo.com/users/Admin@osqo.osqo.com/msp
            export CORE_PEER_ADDRESS=peer1.osqo.osqo.com:7051
            export PORT=7051
        fi

    elif [ $1 = "bcp" ]; then 
        echo $1 $2
        if [ $2 = "peer0" ]; then
            export PEER0_ORG2_CA=${PWD}/../organizations/peerOrganizations/bcp.osqo.com/tlsca/tlsca.bcp.osqo.com-cert.pem
            export CORE_PEER_LOCALMSPID="bcpMSP"
            export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
            export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/bcp.osqo.com/users/Admin@bcp.osqo.com/msp
            export CORE_PEER_ADDRESS=peer0.bcp.osqo.com:8051
            export PORT=8051

        elif [ $2 = "peer1" ]; then
            export PEER1_ORG2_CA=${PWD}/../organizations/peerOrganizations/bcp.osqo.com/tlsca/tlsca.bcp.osqo.com-cert.pem
            export CORE_PEER_LOCALMSPID="bcpMSP"
            export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG2_CA
            export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/bcp.osqo.com/users/Admin@bcp.osqo.com/msp
            export CORE_PEER_ADDRESS=peer1.bcp.osqo.com:9051
            export PORT=9051
        fi

    elif [ $1 = "esp" ]; then 
        echo $1 $2
        if [ $2 = "peer0" ]; then
            export PEER0_ORG3_CA=${PWD}/../organizations/peerOrganizations/esp.osqo.com/tlsca/tlsca.esp.osqo.com-cert.pem
            export CORE_PEER_LOCALMSPID="espMSP"
            export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
            export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/esp.osqo.com/users/Admin@esp.osqo.com/msp
            export CORE_PEER_ADDRESS=peer0.esp.osqo.com:1051
            export PORT=1051

        elif [ $2 = "peer1" ]; then
            export PEER1_ORG3_CA=${PWD}/../organizations/peerOrganizations/esp.osqo.com/tlsca/tlsca.esp.osqo.com-cert.pem
            export CORE_PEER_LOCALMSPID="espMSP"
            export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG3_CA
            export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/esp.osqo.com/users/Admin@esp.osqo.com/msp
            export CORE_PEER_ADDRESS=peer1.esp.osqo.com:1151
            export PORT=1151
        fi
 
    elif [ $1 = "broker" ]; then 
        echo $1 $2
        if [ $2 = "peer0" ]; then
            export PEER0_ORG4_CA=${PWD}/../organizations/peerOrganizations/broker.osqo.com/tlsca/tlsca.broker.osqo.com-cert.pem
            export CORE_PEER_LOCALMSPID="brokerMSP"
            export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG4_CA
            export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/broker.osqo.com/users/Admin@broker.osqo.com/msp
            export CORE_PEER_ADDRESS=peer0.broker.osqo.com:1251
            export PORT=1251

        elif [ $2 = "peer1" ]; then
            export PEER1_ORG4_CA=${PWD}/../organizations/peerOrganizations/broker.osqo.com/tlsca/tlsca.broker.osqo.com-cert.pem
            export CORE_PEER_LOCALMSPID="brokerMSP"
            export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG4_CA
            export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/broker.osqo.com/users/Admin@broker.osqo.com/msp
            export CORE_PEER_ADDRESS=peer1.broker.osqo.com:1351
            export PORT=1351
        fi
    fi
}


function getAllPeerWithCerts(){

    orgs=${1:-"1 2 3 4"}

    export ADDR_COMBINED=" "

    for i in $orgs
    do 
        org_val="ORG${i}"

        setGlobals ${!org_val} peer0
        ADDR_COMBINED+=" --peerAddresses ${CORE_PEER_ADDRESS} --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE}"

        setGlobals ${!org_val} peer1
        ADDR_COMBINED+=" --peerAddresses ${CORE_PEER_ADDRESS} --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE}"
    done

}
