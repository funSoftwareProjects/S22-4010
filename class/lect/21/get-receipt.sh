#!/bin/bash

curl  \
-H "Content-Type: application/json" \
-X POST \
--data '{"jsonrpc":"2.0", "method":"eth_getTransactionReceipt","params":\
   ["0xace7633231e3a3703f517c7b082b79a4b8052b95472cf713c678443c507fe683"],"id":1}' \
http://127.0.0.1:8545/
