#!/bin/bash

. envVar.sh

# Creating Genesis block
mkdir genesis-block
configtxgen -profile ${PROFILE_NAME} -outputBlock ${BLOCKFILE} -channelID $CHANNEL_NAME

sleep 2
