#!/bin/bash
set -x


COMPOSE_CA_FILES=" -f ../fabric-ca/compose-ca/bcp-ca.yaml -f ../fabric-ca/compose-ca/esp-ca.yaml -f ../fabric-ca/compose-ca/osqo-ca.yaml -f ../fabric-ca/compose-ca/broker-ca.yaml -f ../fabric-ca/compose-ca/ordererlink-ca.yaml"

COMPOSE_NETWORK_FILES="-f ../network-compose/bcp.yaml -f ../network-compose/osqo.yaml -f ../network-compose/esp.yaml -f ../network-compose/broker.yaml -f ../network-compose/ordererlink.yaml -f ../network-compose/cli.yaml"

COMPOSE_FILES="${COMPOSE_CA_FILES} ${COMPOSE_NETWORK_FILES}"


echo "compose files loc"
echo $COMPOSE_FILES


DOCKER_SOCK=/var/run/docker.sock docker-compose ${COMPOSE_NETWORK_FILES} down --volumes --remove-orphans
DOCKER_SOCK=/var/run/docker.sock docker-compose ${COMPOSE_CA_FILES} down --volumes --remove-orphans

docker rm -f $(docker ps -aq --filter name='dev-peer*') 2>/dev/null || true
docker image rm -f $(docker images -aq --filter reference='dev-peer*') 2>/dev/null || true

docker volume rm network-compose_orderer2.ordererlink.osqo.com network-compose_orderer3.ordererlink.osqo.com network-compose_orderer4.ordererlink.osqo.com network-compose_orderer5.ordererlink.osqo.com network-compose_orderer.ordererlink.osqo.com network-compose_peer0.bcp.osqo.com network-compose_peer0.osqo.osqo.com network-compose_peer1.bcp.osqo.com network-compose_peer1.osqo.osqo.com network-compose_peer0.broker.osqo.com network-compose_peer1.broker.osqo.com network-compose_peer0.esp.osqo.com network-compose_peer1.esp.osqo.com

# remove channel configuration transactions and certs
docker run --rm -v "$(pwd)/../:/data" busybox sh -c 'cd /data && rm -rf organizations && rm -rf scripts/channel-artifacts'

docker run --rm -v "$(pwd)/../:/data" busybox sh -c 'cd /data && rm -rf fabric-ca/bcp.com/certs/msp fabric-ca/bcp.com/certs/tls-cert.pem fabric-ca/bcp.com/certs/ca-cert.pem fabric-ca/bcp.com/certs/IssuerPublicKey fabric-ca/bcp.com/certs/IssuerRevocationPublicKey fabric-ca/bcp.com/certs/fabric-ca-server.db'
docker run --rm -v "$(pwd)/../:/data" busybox sh -c 'cd /data && rm -rf fabric-ca/esp.com/certs/msp fabric-ca/esp.com/certs/tls-cert.pem fabric-ca/esp.com/certs/ca-cert.pem fabric-ca/esp.com/certs/IssuerPublicKey fabric-ca/esp.com/certs/IssuerRevocationPublicKey fabric-ca/esp.com/certs/fabric-ca-server.db'
docker run --rm -v "$(pwd)/../:/data" busybox sh -c 'cd /data && rm -rf fabric-ca/osqo.com/certs/msp fabric-ca/osqo.com/certs/tls-cert.pem fabric-ca/osqo.com/certs/ca-cert.pem fabric-ca/osqo.com/certs/IssuerPublicKey fabric-ca/osqo.com/certs/IssuerRevocationPublicKey fabric-ca/osqo.com/certs/fabric-ca-server.db'
docker run --rm -v "$(pwd)/../:/data" busybox sh -c 'cd /data && rm -rf fabric-ca/broker.com/certs/msp fabric-ca/broker.com/certs/tls-cert.pem fabric-ca/broker.com/certs/ca-cert.pem fabric-ca/broker.com/certs/IssuerPublicKey fabric-ca/broker.com/certs/IssuerRevocationPublicKey fabric-ca/broker.com/certs/fabric-ca-server.db'

docker run --rm -v "$(pwd)/../:/data" busybox sh -c 'cd /data && rm -rf fabric-ca/ordererlink.com/certs/msp fabric-ca/ordererlink.com/certs/tls-cert.pem fabric-ca/ordererlink.com/certs/ca-cert.pem fabric-ca/ordererlink.com/certs/IssuerPublicKey fabric-ca/ordererlink.com/certs/IssuerRevocationPublicKey fabric-ca/ordererlink.com/certs/fabric-ca-server.db'

#remove channel artifacts
docker run --rm -v "$(pwd):/data" busybox sh -c 'cd /data && rm -rf genesis-block log.txt *.tar.gz'