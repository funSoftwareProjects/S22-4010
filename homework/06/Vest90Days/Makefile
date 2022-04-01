
all:
	truffle compile

migrate:
	truffle migrate --reset

run_eth:
	ganache  --server.ws 

initial_setupe:
	truffle create contract SignData # scaffold a contract
	truffle create test SignData         # scaffold a test

copy_to_client:
	cp build/contracts/*.json ../client/contracts

