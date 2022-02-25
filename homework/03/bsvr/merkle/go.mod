module github.com/Univ-Wyo-Education/S22-4010/homework/03/merkle

go 1.17

require github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/hash v0.0.3

require (
	golang.org/x/crypto v0.0.0-20320112180741-5e0467b6c7ce // indirect
	golang.org/x/sys v0.0.0-20220209214540-3681064d5158 // indirect
)

replace github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/addr => ../addr

replace github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/block => ../block

replace github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/cli => ../cli

replace github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/config => ../config

replace github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/hash => ../hash

replace github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/index => ../index

replace github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/lib => ../lib

replace github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/merkle => ../merkle

replace github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/mine => ../mine

replace github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/transactions => ../transactions

replace golang.org/x/crypto => ../../../../../../../golang.org/x/crypto
