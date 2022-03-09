package main

import (
	"context"
	"fmt"
	"log"
	"math/big"
	"strings"

	"github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"

	gen_event "github.com/Univ-Wyo-Education/S22-4010/class/lect/22/scan-event/eth/contracts"
)

func main() {
	client, err := ethclient.Dial("wss://rinkeby.infura.io/ws") // xyzzy
	if err != nil {
		log.Fatal(err)
	}

	contractAddress := common.HexToAddress("0x147B8eb97fD247D06C4006D269c90C1908Fb5D54") // xyzzy - read in configb
	query := ethereum.FilterQuery{
		FromBlock: big.NewInt(2394201),
		ToBlock:   big.NewInt(2394201),
		Addresses: []common.Address{
			contractAddress,
		},
	}

	logs, err := client.FilterLogs(context.Background(), query)
	if err != nil {
		log.Fatal(err)
	}

	// Generated Code -- Pull in the ABI for the contract.  contractAbi, err := abi.JSON(strings.NewReader(string(gen_event.StoreABI)))
	contractAbi, err := abi.JSON(strings.NewReader(string(gen_event.GenEventMetaData.ABI))) // xyzzy
	if err != nil {
		log.Fatal(err)
	}

	for _, vLog := range logs {
		fmt.Println(vLog.BlockHash.Hex()) // 0x3404b8c050aa0aacd0223e91b5c32fee6400f357764771d0684fa7b3f448f1a8
		fmt.Println(vLog.BlockNumber)     // 2394201
		fmt.Println(vLog.TxHash.Hex())    // 0x280201eda63c9ff6f305fcee51d5eb86167fab40ca3108ec784e8652a0e2b1a6

		event := struct {
			Key   [32]byte
			Value [32]byte
		}{}
		_, err := contractAbi.Unpack("DataSet", vLog.Data) // err := contractAbi.Unpack(&event, "DataSet", vLog.Data) // xyzzy
		if err != nil {
			log.Fatal(err)
		}

		fmt.Println(string(event.Key[:]))   // foo
		fmt.Println(string(event.Value[:])) // bar

		var topics [4]string
		for i := range vLog.Topics {
			topics[i] = vLog.Topics[i].Hex()
		}

		fmt.Println(topics[0]) // 0xe79e73da417710ae99aa2088575580a60415d359acfad9cdd3382d59c80281d4
	}

	eventSignature := []byte("DataSet(bytes32,uint256)")
	hash := crypto.Keccak256Hash(eventSignature)
	fmt.Println(hash.Hex()) // 0xe79e73
}

/*
# github.com/Univ-Wyo-Education/S22-4010/class/lect/22/scan-event
./ScanEvent.go:40:56: undefined: gen_event.StoreABI
./ScanEvent.go:54:7: assignment mismatch: 1 variable but contractAbi.Unpack returns 2 values
./ScanEvent.go:54:28: too many arguments in call to contractAbi.Unpack
	have (*struct { Key [32]byte; Value [32]byte }, string, []byte)
	want (string, []byte)
*/
