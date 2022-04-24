  1: package main
  2: 
  3: import (
  4:     "context"
  5:     "fmt"
  6:     "log"
  7:     "math/big"
  8: 
  9:     "github.com/ethereum/go-ethereum/common"
 10:     "github.com/ethereum/go-ethereum/ethclient"
 11: )
 12: 
 13: func main() {
 14:     client, err := ethclient.Dial("https://cloudflare-eth.com")
 15:     if err != nil {
 16:         log.Fatal(err)
 17:     }
 18: 
 19:     txID := common.HexToHash("0xe330601b05c54116da3b06dd17cf483ab3106fb969989458c8587aac1c34fbf3")
 20:     receipt, err := client.TransactionReceipt(context.Background(), txID)
 21:     if err != nil {
 22:         log.Fatal(err)
 23:     }
 24: 
 25:     logID := "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"
 26:     for _, vLog := range receipt.Logs {
 27:         if vLog.Topics[0].Hex() == logID {
 28:             if len(vLog.Topics) > 2 {
 29:                 id := new(big.Int)
 30:                 id.SetBytes(vLog.Topics[3].Bytes())
 31: 
 32:                 fmt.Println(id.Uint64()) // 1133
 33:             }
 34:         }
 35:     }
 36: }
