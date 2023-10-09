#!/bin/bash

# install chaincode
ver=$1
seq=$2

./chaincode/install-chaincode.sh osqo insureChain ${PWD}/../chaincode/insurechain $ver $seq
./chaincode/install-chaincode.sh bcp insureChain ${PWD}/../chaincode/insurechain $ver $seq
./chaincode/install-chaincode.sh esp insureChain ${PWD}/../chaincode/insurechain $ver $seq
./chaincode/install-chaincode.sh broker insureChain ${PWD}/../chaincode/insurechain $ver $seq

# commit chaincode
./chaincode/commit-chaincode.sh osqo insureChain $ver $seq





# function fun(){

#     orgs=$1

#     echo $orgs
    
#     for i in $orgs
#     do 
#         echo $i
#     done

# }

# fun "1 2 3"