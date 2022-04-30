
all:
	truffle compile

gobuild:
	go build

migrate:
	truffle migrate --reset

run_eth:
	ganache  --server.ws 

initial_setupe:
	truffle create contract SignData # scaffold a contract
	truffle create test SignData         # scaffold a test

copy_to_client:
	cp build/contracts/*.json ../client/contracts

tidy:
	go mod tidy

gen_go:
	( cd ./contracts ; \
		solc --abi KVPair.sol -o . --overwrite )
	( cd ./contracts ; \
		solc --bin KVPair.sol -o . --overwrite )
	( cd ./contracts ; \
		abigen --bin=KVPair.bin --abi=KVPair.abi --pkg=KVPair --out=KVPair.go )
	echo
	mkdir -p Simple777Token
	( cd ./contracts ; \
		solc --abi Simple777Token.sol -o . --overwrite )
	( cd ./contracts ; \
		solc --bin Simple777Token.sol -o . --overwrite )
	( cd ./contracts ; \
		abigen --bin=Simple777Token.bin --abi=Simple777Token.abi --pkg=Simple777Token --out=./Simple777Token/Simple777Token.go )

