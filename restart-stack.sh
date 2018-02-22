#!/bin/sh
set -e
kontena stack rm --force faucet-stack
sleep 5
kontena stack install --deploy kontena.yml
kontena stack logs -f --tail 100 faucet-stack
