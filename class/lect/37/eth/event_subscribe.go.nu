  1: package main
  2: 
  3: import (
  4:     "context"
  5:     "fmt"
  6:     "log"
  7: 
  8:     "github.com/ethereum/go-ethereum"
  9:     "github.com/ethereum/go-ethereum/common"
 10:     "github.com/ethereum/go-ethereum/core/types"
 11:     "github.com/ethereum/go-ethereum/ethclient"
 12: )
 13: 
 14: func main() {
 15:     client, err := ethclient.Dial("wss://rinkeby.infura.io/ws")
 16:     if err != nil {
 17:         log.Fatal(err)
 18:     }
 19: 
 20:     contractAddress := common.HexToAddress("0x147B8eb97fD247D06C4006D269c90C1908Fb5D54")
 21:     query := ethereum.FilterQuery{
 22:         Addresses: []common.Address{contractAddress},
 23:     }
 24: 
 25:     logs := make(chan types.Log)
 26:     sub, err := client.SubscribeFilterLogs(context.Background(), query, logs)
 27:     if err != nil {
 28:         log.Fatal(err)
 29:     }
 30: 
 31:     for {
 32:         select {
 33:         case err := <-sub.Err():
 34:             log.Fatal(err)
 35:         case vLog := <-logs:
 36:             fmt.Println(vLog) // pointer to log event
 37:         }
 38:     }
 39: }
