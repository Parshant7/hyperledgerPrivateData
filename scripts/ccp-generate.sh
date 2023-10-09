#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ./ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)                                                                       
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ./ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}


function createCCP(){

    ORG=$1
    P0PORT=$2
    CAPORT=$3

    PEERPEM=../organizations/peerOrganizations/${ORG}.osqo.com/tlsca/tlsca.${ORG}.osqo.com-cert.pem
    CAPEM=../organizations/peerOrganizations/${ORG}.osqo.com/ca/ca.${ORG}.osqo.com-cert.pem

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/${ORG}.osqo.com/connection-${ORG}.json
    echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/${ORG}.osqo.com/connection-${ORG}.yaml

}

ORG1=osqo 
ORG2=bcp
ORG3=esp
ORG4=broker


createCCP osqo 6051 6054
createCCP bcp 8051 7054
createCCP esp 1051 8054
createCCP broker 1251 9054

