#!/bin/bash

. envVar.sh

ORG=$1

DOCKER_SOCK=/var/run/docker.sock docker-compose -f ../network-compose/${ORG}.yaml up -d 

sleep 1
