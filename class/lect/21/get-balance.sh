#!/bin/bash

#curl  \
#	-H "Content-Type: application/json" \
#	-X POST \
#	--data '{"jsonrpc":"2.0", "method":"eth_getBalance", "params":["0x550B8c20D9679E5B0fcc1a32eeFeA87b021c37DA", "latest"], "id":1}' \
#	http://127.0.0.1:8545

curl http://127.0.0.1:8545/ \
  -X POST \
  -H "Content-Type: application/json" \
  --data '{"method":"eth_getBalance","params":["0xCEE8d07b52252B848A75e6448Ac5Cea967A17b8c", "latest"],"id":1,"jsonrpc":"2.0"}'

