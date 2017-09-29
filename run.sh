#!/bin/bash

# Bitcoind
bitcoind -config=/bitcoin.conf -datadir=/datadrive/bitcoind -daemon

# ElectrumX
source /electrumx.sh
/electrumx/electrumx_server.py

# (echo '{ "id": 5, "method": "blockchain.estimatefee", "params": [10] }'; sleep 2) | ncat localhost 50001