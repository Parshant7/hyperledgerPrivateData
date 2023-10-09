#!/bin/bash
set -x

. envVar.sh

export PATH=${PWD}/../bin:$PATH


COMPOSE_CA_FILES="-f ../fabric-ca/compose-ca/${ORG1}-ca.yaml -f ../fabric-ca/compose-ca/${ORG2}-ca.yaml -f ../fabric-ca/compose-ca/${ORG3}-ca.yaml -f ../fabric-ca/compose-ca/${ORG4}-ca.yaml -f ../fabric-ca/compose-ca/${ORDERER_ORG}-ca.yaml"

DOCKER_SOCK=/var/run/docker.sock docker-compose $COMPOSE_CA_FILES up -d

sleep 3

function register(){

    ORG=$1
    ID_NAME=$2
    ID_SECRET=$3
    ID_TYPE=$4
    
    echo "Registering ${ID_NAME}"

    fabric-ca-client register --caname ca-${ORG} --id.name ${ID_NAME} --id.secret ${ID_SECRET} --id.type ${ID_TYPE} --tls.certfiles "${FABRIC_CA_FOLDER}/ca-cert.pem"
}

function generatePeerMsp(){
    
    ORG=$1
    CA_PORT=$2
    ID_NAME=$3
    ID_SECRET=$4

    echo "Generating the ${ID_NAME} msp"
    fabric-ca-client enroll -u https://${ID_NAME}:${ID_SECRET}@${ORG}.osqo.com:${CA_PORT} --caname ca-${ORG} -M "${ORG_FOLDER}/peers/${ID_NAME}.${ORG}.osqo.com/msp" --csr.hosts ${ID_NAME}.${ORG}.osqo.com --tls.certfiles "${FABRIC_CA_FOLDER}/ca-cert.pem"

    cp "${ORG_FOLDER}/msp/config.yaml" "${ORG_FOLDER}/peers/${ID_NAME}.${ORG}.osqo.com/msp/config.yaml"

    echo "Generating the ${ID_NAME}-tls certificates"

    fabric-ca-client enroll -u https://${ID_NAME}:${ID_SECRET}@${ORG}.osqo.com:${CA_PORT} --caname ca-${ORG} -M "${ORG_FOLDER}/peers/${ID_NAME}.${ORG}.osqo.com/tls" --enrollment.profile tls --csr.hosts ${ID_NAME}.${ORG}.osqo.com --csr.hosts localhost --tls.certfiles "${FABRIC_CA_FOLDER}/ca-cert.pem"

    # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
    cp "${ORG_FOLDER}/peers/${ID_NAME}.${ORG}.osqo.com/tls/tlscacerts/"* "${ORG_FOLDER}/peers/${ID_NAME}.${ORG}.osqo.com/tls/ca.crt"
    cp "${ORG_FOLDER}/peers/${ID_NAME}.${ORG}.osqo.com/tls/signcerts/"* "${ORG_FOLDER}/peers/${ID_NAME}.${ORG}.osqo.com/tls/server.crt"
    cp "${ORG_FOLDER}/peers/${ID_NAME}.${ORG}.osqo.com/tls/keystore/"* "${ORG_FOLDER}/peers/${ID_NAME}.${ORG}.osqo.com/tls/server.key"

}

function generateUserMSP(){

    ORG=$1
    CA_PORT=$2
    ID_NAME=$3
    ID_SECRET=$4

    echo "Generating the ${ID_NAME} msp"

    fabric-ca-client enroll -u https://${ID_NAME}:${ID_SECRET}@${ORG}.osqo.com:${CA_PORT} --caname ca-${ORG} -M "${ORG_FOLDER}/users/${ID_NAME}@${ORG}.osqo.com/msp" --tls.certfiles "${FABRIC_CA_FOLDER}/ca-cert.pem"

    cp "${ORG_FOLDER}/msp/config.yaml" "${ORG_FOLDER}/users/${ID_NAME}@${ORG}.osqo.com/msp/config.yaml"
}
    

function generateAdminMSP(){

    ORG=$1
    CA_PORT=$2
    ID_NAME=$3
    ID_SECRET=$4

    echo "Generating the ${ID_NAME} msp"

    fabric-ca-client enroll -u https://${ID_NAME}:${ID_SECRET}@${ORG}.osqo.com:${CA_PORT} --caname ca-${ORG} -M "${ORG_FOLDER}/users/Admin@${ORG}.osqo.com/msp" --tls.certfiles "${FABRIC_CA_FOLDER}/ca-cert.pem"

    cp "${ORG_FOLDER}/msp/config.yaml" "${ORG_FOLDER}/users/Admin@${ORG}.osqo.com/msp/config.yaml"
}


function enrollOrderers(){

  ORG=$1
  CA_PORT=$2
  ORDERER_NO=$3
  ID_NAME=$4
  ID_SECRET=$5

  fabric-ca-client enroll -u https://${ID_NAME}:${ID_SECRET}@${ORG}.osqo.com:${CA_PORT} --caname ca-${ORG} -M "${ORG_FOLDER}/orderers/${ORDERER_NO}.${ORG}.osqo.com/msp" --csr.hosts ${ORDERER_NO}.${ORG}.osqo.com --csr.hosts localhost --tls.certfiles "${FABRIC_CA_FOLDER}/ca-cert.pem"

  cp "${ORG_FOLDER}/msp/config.yaml" "${ORG_FOLDER}/orderers/${ORDERER_NO}.${ORG}.osqo.com/msp/config.yaml"

  fabric-ca-client enroll -u https://${ID_NAME}:${ID_SECRET}@${ORG}.osqo.com:${CA_PORT} --caname ca-${ORG} -M "${ORG_FOLDER}/orderers/${ORDERER_NO}.${ORG}.osqo.com/tls" --enrollment.profile tls --csr.hosts ${ORDERER_NO}.${ORG}.osqo.com --csr.hosts localhost --tls.certfiles "${FABRIC_CA_FOLDER}/ca-cert.pem"

  # Copy the tls CA cert, server cert, server keystore to well known file names in the orderer's tls directory that are referenced by orderer startup config
  cp "${ORG_FOLDER}/orderers/${ORDERER_NO}.${ORG}.osqo.com/tls/tlscacerts/"* "${ORG_FOLDER}/orderers/${ORDERER_NO}.${ORG}.osqo.com/tls/ca.crt"
  cp "${ORG_FOLDER}/orderers/${ORDERER_NO}.${ORG}.osqo.com/tls/signcerts/"* "${ORG_FOLDER}/orderers/${ORDERER_NO}.${ORG}.osqo.com/tls/server.crt"
  cp "${ORG_FOLDER}/orderers/${ORDERER_NO}.${ORG}.osqo.com/tls/keystore/"* "${ORG_FOLDER}/orderers/${ORDERER_NO}.${ORG}.osqo.com/tls/server.key"

  # Copy orderer org's CA cert to orderer's /msp/tlscacerts directory (for use in the orderer MSP definition)
  mkdir -p "${ORG_FOLDER}/orderers/${ORDERER_NO}.${ORG}.osqo.com/msp/tlscacerts"

  cp "${ORG_FOLDER}/orderers/${ORDERER_NO}.${ORG}.osqo.com/tls/tlscacerts/"* "${ORG_FOLDER}/orderers/${ORDERER_NO}.${ORG}.osqo.com/msp/tlscacerts/tlsca.${ORG}.osqo.com-cert.pem"

}


function createPeerOrgs(){
    
    ORG=$1
    CA_PORT=$2

    # creating the variables ease the migration
    
    export FABRIC_CA_FOLDER="${PWD}/../fabric-ca/${ORG}.com/certs"
    export ORG_FOLDER="${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com"

    mkdir -p ../organizations/peerOrganizations/${ORG}.osqo.com/
    export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/

    fabric-ca-client enroll -u https://admin:adminpw@${ORG}.osqo.com:${CA_PORT} --caname ca-${ORG} --tls.certfiles "${FABRIC_CA_FOLDER}/ca-cert.pem"

    #------------------------------------------------------------

    echo "NodeOUs:
      Enable: true
      ClientOUIdentifier:
        Certificate: cacerts/${ORG}-osqo-com-${CA_PORT}-ca-${ORG}.pem
        OrganizationalUnitIdentifier: client
      PeerOUIdentifier:
        Certificate: cacerts/${ORG}-osqo-com-${CA_PORT}-ca-${ORG}.pem
        OrganizationalUnitIdentifier: peer
      AdminOUIdentifier:
        Certificate: cacerts/${ORG}-osqo-com-${CA_PORT}-ca-${ORG}.pem
        OrganizationalUnitIdentifier: admin
      OrdererOUIdentifier:
        Certificate: cacerts/${ORG}-osqo-com-${CA_PORT}-ca-${ORG}.pem
        OrganizationalUnitIdentifier: orderer" > "${ORG_FOLDER}/msp/config.yaml"

    #------------------------------------------------------------

    # Since the CA serves as both the organization CA and TLS CA, copy the org's root cert that was generated by CA startup into the org level ca and tlsca directories

    # Copy ORG's CA cert to ORG's /msp/tlscacerts directory (for use in the channel MSP definition)
    mkdir -p "${ORG_FOLDER}/msp/tlscacerts"
    cp "${FABRIC_CA_FOLDER}/ca-cert.pem" "${ORG_FOLDER}/msp/tlscacerts/ca.crt"

    # Copy ORG's CA cert to ORG's /tlsca directory (for use by clients)
    mkdir -p "${ORG_FOLDER}/tlsca"
    cp "${FABRIC_CA_FOLDER}/ca-cert.pem" "${ORG_FOLDER}/tlsca/tlsca.${ORG}.osqo.com-cert.pem"

    # Copy ORG's CA cert to ranabxy's /ca directory (for use by clients)
    mkdir -p "${ORG_FOLDER}/ca"
    cp "${FABRIC_CA_FOLDER}/ca-cert.pem" "${ORG_FOLDER}/ca/ca.${ORG}.osqo.com-cert.pem"


    #------------------------------------------------------------

    register ${ORG} peer0 peer0pw peer
    register ${ORG} peer1 peer1pw peer
    register ${ORG} user1 user1pw client
    register ${ORG} ${ORG}Admin ${ORG}Adminpw admin

    #------------------------------------------------------------

    generatePeerMsp ${ORG} ${CA_PORT} peer0 peer0pw 
    generatePeerMsp ${ORG} ${CA_PORT} peer1 peer1pw 

    generateUserMSP ${ORG} ${CA_PORT} user1 user1pw
    generateAdminMSP ${ORG} ${CA_PORT} ${ORG}Admin ${ORG}Adminpw

}


function createOrdererOrgs(){

  ORG=$1
  CA_PORT=$2

  # creating the variables ease the migration
  
  export FABRIC_CA_FOLDER="${PWD}/../fabric-ca/${ORG}.com/certs"
  export ORG_FOLDER="${PWD}/../organizations/ordererOrganizations/${ORG}.osqo.com"

  mkdir -p ../organizations/ordererOrganizations/${ORG}.osqo.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/ordererOrganizations/${ORG}.osqo.com/

  fabric-ca-client enroll -u https://admin:adminpw@${ORG}.osqo.com:${CA_PORT} --caname ca-${ORG} --tls.certfiles "${FABRIC_CA_FOLDER}/ca-cert.pem"

  #------------------------------------------------------------

  echo "NodeOUs:
    Enable: true
    ClientOUIdentifier:
      Certificate: cacerts/${ORG}-osqo-com-${CA_PORT}-ca-${ORG}.pem
      OrganizationalUnitIdentifier: client
    PeerOUIdentifier:
      Certificate: cacerts/${ORG}-osqo-com-${CA_PORT}-ca-${ORG}.pem
      OrganizationalUnitIdentifier: peer
    AdminOUIdentifier:
      Certificate: cacerts/${ORG}-osqo-com-${CA_PORT}-ca-${ORG}.pem
      OrganizationalUnitIdentifier: admin
    OrdererOUIdentifier:
      Certificate: cacerts/${ORG}-osqo-com-${CA_PORT}-ca-${ORG}.pem
      OrganizationalUnitIdentifier: orderer" > "${ORG_FOLDER}/msp/config.yaml"

  #------------------------------------------------------------

  # Since the CA serves as both the organization CA and TLS CA, copy the org's root cert that was generated by CA startup into the org level ca and tlsca directories

  # Copy ORG's CA cert to ORG's /msp/tlscacerts directory (for use in the channel MSP definition)
  mkdir -p "${ORG_FOLDER}/msp/tlscacerts"
  cp "${FABRIC_CA_FOLDER}/ca-cert.pem" "${ORG_FOLDER}/msp/tlscacerts/ca.crt"

  # Copy ORG's CA cert to ORG's /tlsca directory (for use by clients)
  mkdir -p "${ORG_FOLDER}/tlsca"
  cp "${FABRIC_CA_FOLDER}/ca-cert.pem" "${ORG_FOLDER}/tlsca/tlsca.${ORG}.osqo.com-cert.pem"


  register ${ORG} orderer ordererpw orderer
  register ${ORG} ordererAdmin ordererAdminpw admin


  enrollOrderers $ORG $CA_PORT orderer orderer ordererpw 

  generateAdminMSP ${ORG} ${CA_PORT} ordererAdmin ordererAdminpw

  enrollOrderers $ORG $CA_PORT orderer2 orderer ordererpw 
  enrollOrderers $ORG $CA_PORT orderer3 orderer ordererpw 
  enrollOrderers $ORG $CA_PORT orderer4 orderer ordererpw 
  enrollOrderers $ORG $CA_PORT orderer5 orderer ordererpw 

}




createPeerOrgs $ORG1 6054
createPeerOrgs $ORG2 7054
createPeerOrgs $ORG3 8054
createPeerOrgs $ORG4 9054

createOrdererOrgs $ORDERER_ORG 1054

sleep 3