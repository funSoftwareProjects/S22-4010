package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math/big"
	"os"
	"strings"

	"github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/pschlump/godebug"

	kv "github.com/Univ-Wyo-Education/S22-4010/class/lect/37/eth/contracts"
)

type CfgType struct {
	Addrs map[string]string
}

func main() {

	// client, err := ethclient.Dial("wss://rinkeby.infura.io/ws")
	client, err := ethclient.Dial("ws://127.0.0.1:8546") // connect to local geth or ganache
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to connect to network/geth/ganache.  Error:%s\n", err)
		os.Exit(1)
	}

	buf, err := ioutil.ReadFile("cfg.json")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to open cfg.json for read.  Error:%s\n", err)
		os.Exit(1)
	}
	var cfg CfgType
	err = json.Unmarshal(buf, &cfg)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to parse cfg.json.  Error:%s\n", err)
		os.Exit(1)
	}

	contractAddress := common.HexToAddress(cfg.Addrs["KVPair"])
	query := ethereum.FilterQuery{
		FromBlock: big.NewInt(1),
		ToBlock:   big.NewInt(5000000),
		Addresses: []common.Address{
			contractAddress,
		},
	}

	logs, err := client.FilterLogs(context.Background(), query)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error:%s at:%s\n", err, godebug.LF())
		os.Exit(1)
	}

	contractAbi, err := abi.JSON(strings.NewReader(string(kv.KVPairABI)))
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error:%s at:%s\n", err, godebug.LF())
		os.Exit(1)
	}

	eventSignature := []byte("SetKVEvent(bytes32,bytes32)")
	hash := crypto.Keccak256Hash(eventSignature)
	fmt.Printf("Event Signature Is: 0x%x\n", hash)

	for _, vLog := range logs {
		fmt.Printf("BlockHash 0x%x\n", vLog.BlockHash)
		fmt.Printf("BlockNumber: %d\n", vLog.BlockNumber)
		fmt.Printf("Block Tx: 0x%0x\n", vLog.TxHash)

		// if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
		eventX, err := contractAbi.Unpack("SetKVEvent", vLog.Data)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error:%s at:%s\n", err, godebug.LF())
			os.Exit(1)
		}

		fmt.Printf("Event Data: %s\n", godebug.SVarI(eventX))

		var topics [4]string
		for i := range vLog.Topics {
			topics[i] = vLog.Topics[i].Hex()
		}

		fmt.Printf("Event Topics: %s\n", topics[0])
	}

}
