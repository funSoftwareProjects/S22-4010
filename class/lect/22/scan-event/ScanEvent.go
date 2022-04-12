package main

// MIT Licensed -- Based on original code
// https://goethereumbook.org/en/event-read/
// the code has been fixed to work with 8.1 solc and Eth 1.10.x

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

// These are the values pulled in from ./cfg.json file.
type GlobalConfig struct {
	ContractAddress string   `json:"contract_address"`
	ClientWSSUrl    string   `json:"client_wss_url"`
	DbFlags         []string `json:"db_flags"`
}

var gCfg GlobalConfig
var DbOn map[string]bool = make(map[string]bool)

func main() {

	// --------------------------------------------------------------------------------------
	// Read global config
	// --------------------------------------------------------------------------------------
	ReadJson("cfg.json", &gCfg)
	if len(gCfg.DbFlags) > 0 {
		for _, x := range gCfg.DbFlags {
			DbOn[x] = true
		}
	}

	for _, k := range gCfg.DbFlags {
		DbOn[k] = true
	}

	if DbOn["dump-global-config"] {
		fmt.Printf("Global Config:%s\n", SVarI(gCfg))
	}

	client, err := ethclient.Dial(gCfg.ClientWSSUrl)
	if err != nil {
		log.Fatal(err)
	}

	// --------------------------------------------------------------------------------------
	// Process contract
	// --------------------------------------------------------------------------------------
	contractAddress := common.HexToAddress(gCfg.ContractAddress)
	query := ethereum.FilterQuery{
		FromBlock: big.NewInt(2394201),
		ToBlock:   big.NewInt(2394201),
		Addresses: []common.Address{
			contractAddress,
		},
	}

	// --------------------------------------------------------------------------------------
	// Search Chain / Logs
	// --------------------------------------------------------------------------------------
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
		fmt.Printf("0x%x\n", vLog.BlockHash.Hex()) // 0x3404b8c050aa0aacd0223e91b5c32fee6400f357764771d0684fa7b3f448f1a8
		fmt.Printf("%v\n", vLog.BlockNumber)       // 2394201
		fmt.Printf("0x%x\n", vLog.TxHash.Hex())    // 0x280201eda63c9ff6f305fcee51d5eb86167fab40ca3108ec784e8652a0e2b1a6

		event := struct {
			Key   [32]byte
			Value [32]byte
		}{}
		_, err := contractAbi.Unpack("DataSet", vLog.Data) // err := contractAbi.Unpack(&event, "DataSet", vLog.Data) // xyzzy
		if err != nil {
			log.Fatal(err)
		}

		fmt.Printf("0x%x\n", string(event.Key[:]))
		fmt.Printf("0x%x\n", string(event.Value[:]))

		var topics [4]string
		for i := range vLog.Topics {
			topics[i] = vLog.Topics[i].Hex()
		}

		fmt.Printf(topics[0]) // 0xe79e73da417710ae99aa2088575580a60415d359acfad9cdd3382d59c80281d4
	}

	eventSignature := []byte("DataSet(bytes32,bytes32)")
	hash := crypto.Keccak256Hash(eventSignature)
	fmt.Printf("%s\n", hash.Hex()) // 0xe79e73
}
