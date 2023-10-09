#!/bin/bash
set -x

# generate-msp
./generate-msp.sh

# ccp
./ccp-generate.sh  

# genesis block
./genesis.sh

# start organization's container
./start-org.sh osqo
./start-org.sh bcp
./start-org.sh esp
./start-org.sh broker


# create channel 
./createChannel.sh

# Join all the peers of the org to the channel 
./joinChannel.sh osqo
./joinChannel.sh bcp
./joinChannel.sh esp
./joinChannel.sh broker

# install chaincode
./chaincode/install-chaincode.sh osqo insureChain ${PWD}/../chaincode/insurechain 1.0 1
./chaincode/install-chaincode.sh bcp insureChain ${PWD}/../chaincode/insurechain 1.0 1
./chaincode/install-chaincode.sh esp insureChain ${PWD}/../chaincode/insurechain 1.0 1
./chaincode/install-chaincode.sh broker insureChain ${PWD}/../chaincode/insurechain 1.0 1

# commit chaincode
./chaincode/commit-chaincode.sh osqo insureChain 1.0 1


# query invoke

# ./chaincode/query-invoke.sh osqo invoke insureChain '{"Args":["createUser","{\"osqoId\":\"1234\",\"firstName\":\"Parshant\",\"lastName\":\"Khichi\",\"email\":\"parshantkhichi@gmail.com\",\"status\":\"approved\",\"inProgress\":\"false\"}"]}'

# ./chaincode/query-invoke.sh osqo query insureChain '{"Args":["getAllusers"]}'
