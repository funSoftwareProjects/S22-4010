  1: package main
  2: 
  3: import (
  4:     "context"
  5:     "encoding/json"
  6:     "fmt"
  7:     "io/ioutil"
  8:     "math/big"
  9:     "os"
 10:     "strings"
 11: 
 12:     "github.com/ethereum/go-ethereum"
 13:     "github.com/ethereum/go-ethereum/accounts/abi"
 14:     "github.com/ethereum/go-ethereum/common"
 15:     "github.com/ethereum/go-ethereum/crypto"
 16:     "github.com/ethereum/go-ethereum/ethclient"
 17:     "github.com/pschlump/godebug"
 18: 
 19:     kv "github.com/Univ-Wyo-Education/S22-4010/class/lect/37/eth/contracts"
 20: )
 21: 
 22: type CfgType struct {
 23:     Addrs map[string]string
 24: }
 25: 
 26: func main() {
 27: 
 28:     // client, err := ethclient.Dial("wss://rinkeby.infura.io/ws")
 29:     client, err := ethclient.Dial("ws://127.0.0.1:8546") // connect to local geth or ganache
 30:     if err != nil {
 31:         fmt.Fprintf(os.Stderr, "Unable to connect to network/geth/ganache.  Error:%s\n", err)
 32:         os.Exit(1)
 33:     }
 34: 
 35:     buf, err := ioutil.ReadFile("cfg.json")
 36:     if err != nil {
 37:         fmt.Fprintf(os.Stderr, "Unable to open cfg.json for read.  Error:%s\n", err)
 38:         os.Exit(1)
 39:     }
 40:     var cfg CfgType
 41:     err = json.Unmarshal(buf, &cfg)
 42:     if err != nil {
 43:         fmt.Fprintf(os.Stderr, "Unable to parse cfg.json.  Error:%s\n", err)
 44:         os.Exit(1)
 45:     }
 46: 
 47:     contractAddress := common.HexToAddress(cfg.Addrs["KVPair"])
 48:     query := ethereum.FilterQuery{
 49:         FromBlock: big.NewInt(1),
 50:         ToBlock:   big.NewInt(5000000),
 51:         Addresses: []common.Address{
 52:             contractAddress,
 53:         },
 54:     }
 55: 
 56:     logs, err := client.FilterLogs(context.Background(), query)
 57:     if err != nil {
 58:         fmt.Fprintf(os.Stderr, "Error:%s at:%s\n", err, godebug.LF())
 59:         os.Exit(1)
 60:     }
 61: 
 62:     contractAbi, err := abi.JSON(strings.NewReader(string(kv.KVPairABI)))
 63:     if err != nil {
 64:         fmt.Fprintf(os.Stderr, "Error:%s at:%s\n", err, godebug.LF())
 65:         os.Exit(1)
 66:     }
 67: 
 68:     eventSignature := []byte("SetKVEvent(bytes32,bytes32)")
 69:     hash := crypto.Keccak256Hash(eventSignature)
 70:     fmt.Printf("Event Signature Is: 0x%x\n", hash)
 71: 
 72:     for _, vLog := range logs {
 73:         fmt.Printf("BlockHash 0x%x\n", vLog.BlockHash)
 74:         fmt.Printf("BlockNumber: %d\n", vLog.BlockNumber)
 75:         fmt.Printf("Block Tx: 0x%0x\n", vLog.TxHash)
 76: 
 77:         // if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
 78:         eventX, err := contractAbi.Unpack("SetKVEvent", vLog.Data)
 79:         if err != nil {
 80:             fmt.Fprintf(os.Stderr, "Error:%s at:%s\n", err, godebug.LF())
 81:             os.Exit(1)
 82:         }
 83: 
 84:         fmt.Printf("Event Data: %s\n", godebug.SVarI(eventX))
 85: 
 86:         var topics [4]string
 87:         for i := range vLog.Topics {
 88:             topics[i] = vLog.Topics[i].Hex()
 89:         }
 90: 
 91:         fmt.Printf("Event Topics: %s\n", topics[0])
 92:     }
 93: 
 94: }
