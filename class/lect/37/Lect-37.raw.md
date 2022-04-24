
m4_include(../../../setup.m4)

# Lecture 37 - Things Ethereum Needs

The simple contract that is in most of these examples

```
m4_include(eth/contracts/KVPair.sol.nu)
```

The commands to build the .go code (From Makefile)

```
gen_go:
	( cd ./contracts ; \
		solc --abi KVPair.sol -o . --overwrite )
	( cd ./contracts ; \
		solc --bin KVPair.sol -o . --overwrite )
	( cd ./contracts ; \
		abigen --bin=KVPair.bin --abi=KVPair.abi --pkg=KVPair --out=KVPair.go )
```

## Events that lead to outside actions

```
m4_include(eth/event_read.go.nu)
```

```
m4_include(eth/erc777events.go.nu)
```

## Scheduler

```
m4_include(eth/call_contract_daily.go.nu)
```


