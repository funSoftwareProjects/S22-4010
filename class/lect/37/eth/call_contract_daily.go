package main

import (
	"context"
	"crypto/ecdsa"
	"fmt"
	"log"
	"math/big"
	"os"
	"time"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/robfig/cron"
	log "github.com/sirupsen/logrus"

	kv "github.com/Univ-Wyo-Education/S22-4010/class/lect/37/eth/contracts"
)

func init() {
	log.SetLevel(log.InfoLevel)
	log.SetFormatter(&log.TextFormatter{FullTimestamp: true})
}

func main() {
	log.Info("Create new cron")
	c := cron.New()
	c.AddFunc("0 0 * * *", func() {
		log.Info("[Job 1]Every day at midnight\n")
		callContract()
	})

	// Start cron with one scheduled job
	log.Info("Start cron")
	c.Start()
	time.Sleep(1 * time.Minute)
}

func callContract() {

	// client, err := ethclient.Dial("https://rinkeby.infura.io")
	client, err := ethclient.Dial("http://127.0.0.1:8545")
	if err != nil {
		log.Fatal(err)
	}

	privateKey, err := crypto.HexToECDSA(os.Getenv("PrivateKey_for_127"))
	if err != nil {
		log.Fatal(err)
	}

	publicKey := privateKey.Public()
	publicKeyECDSA, ok := publicKey.(*ecdsa.PublicKey)
	if !ok {
		log.Fatal("cannot assert type: publicKey is not of type *ecdsa.PublicKey")
	}

	fromAddress := crypto.PubkeyToAddress(*publicKeyECDSA)
	nonce, err := client.PendingNonceAt(context.Background(), fromAddress)
	if err != nil {
		log.Fatal(err)
	}

	gasPrice, err := client.SuggestGasPrice(context.Background())
	if err != nil {
		log.Fatal(err)
	}

	auth := bind.NewKeyedTransactor(privateKey)
	auth.Nonce = big.NewInt(int64(nonce))
	auth.Value = big.NewInt(0)     // in wei
	auth.GasLimit = uint64(600000) // in units
	auth.GasPrice = gasPrice

	address := common.HexToAddress(cfg.Addrs["KVPair"])
	instance, err := kv.NewKVPair(address, client)
	if err != nil {
		log.Fatal(err)
	}

	// Setup to call function that is a tranaction (requires gas) and changes data.

	key := [32]byte{}
	value := [32]byte{}
	copy(key[:], []byte("hello"))
	copy(value[:], []byte("world"))

	tx, err := instance.SetKVPair(auth, key, value)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("tx sent: %s\n", tx.Hash().Hex())

	time.Sleep(1 * time.Minute) // wait for data to be on-chain

	result, err := instance.TheData(nil, key)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Key Lookup: %s\n", result) // "world"
}
