set -x
. ./envVar.sh


ORG=$1
OUERY_INVOKE=$2
CC_NAME=$3
ARGUMENTS=$4
TRANSIENT=$5

setGlobals $ORG peer0

if [ $OUERY_INVOKE = "query" ]; then

    peer chaincode query -C $CHANNEL_NAME -n $CC_NAME -c $ARGUMENTS

elif [ $OUERY_INVOKE = "invoke" ]; then
    
    getAllPeerWithCerts 

    peer chaincode invoke -o ${ORDERER_ADDRESS}:${ORDERER_PORT} --ordererTLSHostnameOverride ${ORDERER_ADDRESS} --tls --cafile "$ORDERER_CA" --channelID $CHANNEL_NAME --name ${CC_NAME} ${ADDR_COMBINED} -c "${ARGUMENTS}"

elif [ $OUERY_INVOKE = "privateQuery" ]; then

    getAllPeerWithCerts "1"

    TRANSIENT_ENCODED=$(echo -n "$TRANSIENT" | base64 -w 0)
    
    echo $TRANSIENT_ENCODED
    
    setGlobals $ORG peer0

    peer chaincode invoke -o ${ORDERER_ADDRESS}:${ORDERER_PORT} --ordererTLSHostnameOverride ${ORDERER_ADDRESS} --tls --cafile "$ORDERER_CA" --channelID $CHANNEL_NAME --name ${CC_NAME} ${ADDR_COMBINED} -c "${ARGUMENTS}" --transient "{\"car\": \"${TRANSIENT_ENCODED}\"}"

elif [ $OUERY_INVOKE = "privateInvoke" ]; then
    
    getAllPeerWithCerts 

    TRANSIENT_ENCODED=$(echo -n "$TRANSIENT" | base64 -w 0)
    
    echo $TRANSIENT_ENCODED
    
    setGlobals $ORG peer0

    peer chaincode invoke -o ${ORDERER_ADDRESS}:${ORDERER_PORT} --ordererTLSHostnameOverride ${ORDERER_ADDRESS} --tls --cafile "$ORDERER_CA" --channelID $CHANNEL_NAME --name ${CC_NAME} ${ADDR_COMBINED} -c "${ARGUMENTS}" --transient "{\"car\": \"${TRANSIENT_ENCODED}\"}"
fi

# peer chaincode invoke -o ${ORDERER_ADDRESS}:${ORDERER_PORT} --ordererTLSHostnameOverride ${ORDERER_ADDRESS} --tls --cafile "$ORDERER_CA" --channelID $CHANNEL_NAME --name ${CC_NAME} ${ADDR_COMBINED} -c "${ARGUMENTS}" --transient "{\"asset_properties\":\"dfdfdf\"}"

# query chaincode
# . ./chaincode/query-invoke.sh osqo query insureChain '{"Args":["getAllusers"]}'

# invoke chaincode
# . ./chaincode/query-invoke.sh osqo invoke insureChain '{"Args":["createUser","{\"osqoId\":\"1234\",\"firstName\":\"Parshant\",\"lastName\":\"Khichi\",\"email\":\"parshantkhichi@gmail.com\",\"status\":\"approved\",\"inProgress\":\"false\"}"]}'

# create private data with transient field
# . ./chaincode/query-invoke.sh osqo privateInvoke insureChain '{"Args": ["createCar"]}' '{\"id\":\"1112\",\"model\":\"verna\",\"price\":\"1600000\",\"owner\":\"Parshant\"}'

# . ./chaincode/query-invoke.sh osqo privateInvoke insureChain '{"Args": ["createCar"]}' '{"id":"1112","model":"verna"}'

# get private data with transient field
# . ./chaincode/query-invoke.sh osqo privateQuery insureChain '{"Args": ["getCar"]}' '{"id":"1112"}'





# . ./chaincode/query-invoke.sh osqo privateInvoke insureChain '{"Args": ["createCar"]}' "{\"data\": \"this is data\"}"

# . ./chaincode/query-invoke.sh osqo privateInvoke insureChain '{"Args":["getCar","12"]}'

# --transient "{\"asset_properties\":\"$ASSET_PROPERTIES\"}"

# . ./chaincode/query-invoke.sh osqo invoke insureChain peer chaincode invoke insureChain '{"Args": [{ "osqoId": "1234", "firstName": "Parshant", "lastName": "Khichi", "email": "parshantkhichi@gmail.com", "status": "approved", "inProgress": "false" }]}'

# setGlobals
# peer chaincode invoke -o orderer.ordererlink.com:7050 --ordererTLSHostnameOverride orderer.ordererlink.com --tls --cafile "$ORDERER_CA" --channelID $CHANNEL_NAME --name ${CC_NAME} --peerAddresses peer0.ranbaxy.com:6051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/ranbaxy.com/tlsca/tlsca.ranbaxy.com-cert.pem" --peerAddresses peer1.ranbaxy.com:7051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/ranbaxy.com/tlsca/tlsca.ranbaxy.com-cert.pem" --peerAddresses peer0.fda.com:8051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/fda.com/tlsca/tlsca.fda.com-cert.pem" --peerAddresses peer1.fda.com:9051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/fda.com/tlsca/tlsca.fda.com-cert.pem" --peerAddresses peer0.medlineindustries.com:1051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/medlineindustries.com/tlsca/tlsca.medlineindustries.com-cert.pem" --peerAddresses peer1.medlineindustries.com:1151 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/medlineindustries.com/tlsca/tlsca.medlineindustries.com-cert.pem" --peerAddresses peer0.unitedhealthgroup.com:1251 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/unitedhealthgroup.com/tlsca/tlsca.unitedhealthgroup.com-cert.pem" --peerAddresses peer1.unitedhealthgroup.com:1351 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/unitedhealthgroup.com/tlsca/tlsca.unitedhealthgroup.com-cert.pem" -c '{"function":"createUser","Args":["2321344", "Parshant", "Khichi", "pk@gmail.com", "approved", "false", "bcp"]}' 

