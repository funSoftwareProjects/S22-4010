module github.com/Univ-Wyo-Education/S22-4010/homework/04/mine

go 1.17

require (
	github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/block v0.0.3
	github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/hash v0.0.3
)

require (
	github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/addr v0.0.3 // indirect
	github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/lib v0.0.3 // indirect
	github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/merkle v0.0.3 // indirect
	github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/transactions v0.0.3 // indirect
	github.com/btcsuite/btcd v0.20.1-beta // indirect
	github.com/ethereum/go-ethereum v1.10.15 // indirect
	github.com/mattn/go-colorable v0.1.12 // indirect
	github.com/mattn/go-isatty v0.0.14 // indirect
	github.com/pschlump/MiscLib v1.0.3 // indirect
	github.com/pschlump/ansi v1.0.1 // indirect
	github.com/pschlump/godebug v1.0.4 // indirect
	github.com/pschlump/json v1.12.0 // indirect
	golang.org/x/crypto v0.0.0-20320112180741-5e0467b6c7ce // indirect
	golang.org/x/sys v0.0.0-20220209214540-3681064d5158 // indirect
)

replace github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/addr => ../addr

replace github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/block => ../block

replace github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/cli => ../cli

replace github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/config => ../config

replace github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/hash => ../hash

replace github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/index => ../index

replace github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/lib => ../lib

replace github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/merkle => ../merkle

replace github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/mine => ../mine

replace github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/transactions => ../transactions

replace golang.org/x/crypto => ../../../../../../../golang.org/x/crypto
