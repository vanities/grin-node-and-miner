# grin-node-and-miner
host a grin node! mine grin! host and mine grin! compose files for grin

## Setting up a password

1. edit the Dockerfile and docker-compose file to change the password


## Installation

ensure you have docker and docker-compose installed then run these commands: (warning, the node will have to sync first!)


## Running the node, wallet, and miner

1. `make`
2. `docker-compose up`


## Running the node, wallet, or miner individually

1. `make`
2. `docker-compose up grin-node grin-wallet grin-miner`


## Uninstallation

1. `make clean` 
