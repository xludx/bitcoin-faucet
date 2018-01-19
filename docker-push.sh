#!/bin/bash
if [ -z "$1" ]
  then
    echo "Error!"
    echo ""
    echo "Usage: ./docker-build.sh TAG"
    exit 1
fi
TAG=$1
docker push docker.io/ludx/particl-faucet:$TAG
docker push docker.io/ludx/particl-faucet:latest


