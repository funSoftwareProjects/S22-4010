
all:
	echo go build

tidy:
	go mod tidy

gen_go:
	( cd ./eth/contracts ; \
		solc --abi GenEvent.sol -o . --overwrite )
	( cd ./eth/contracts ; \
		solc --bin GenEvent.sol -o . --overwrite )
	( cd ./eth/contracts ; \
		abigen --bin=GenEvent.bin --abi=GenEvent.abi --pkg=gen_event --out=GenEvent.go )

# ./eth/contracts/GenEvent.sol
