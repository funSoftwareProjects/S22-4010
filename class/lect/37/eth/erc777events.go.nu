  1: package main
  2: 
  3: // Program to expose all of the transfers in a ERC777/ERC20/ERC1155 type contract.
  4: // Watches events for transfers.
  5: 
  6: import (
  7:     "context"
  8:     "encoding/json"
  9:     "fmt"
 10:     "io/ioutil"
 11:     "log"
 12:     "math/big"
 13:     "os"
 14:     "strings"
 15: 
 16:     simple777 "github.com/Univ-Wyo-Education/S22-4010/class/lect/37/eth/Simple777Token"
 17:     "github.com/ethereum/go-ethereum"
 18:     "github.com/ethereum/go-ethereum/accounts/abi"
 19:     "github.com/ethereum/go-ethereum/common"
 20:     "github.com/ethereum/go-ethereum/crypto"
 21:     "github.com/ethereum/go-ethereum/ethclient"
 22: )
 23: 
 24: // LogTransfer ..
 25: type LogTransfer struct {
 26:     From   common.Address
 27:     To     common.Address
 28:     Tokens *big.Int
 29: }
 30: 
 31: type CfgType struct {
 32:     Addrs map[string]string
 33: }
 34: 
 35: // LogApproval ..
 36: type LogApproval struct {
 37:     TokenOwner common.Address
 38:     Spender    common.Address
 39:     Tokens     *big.Int
 40: }
 41: 
 42: func main() {
 43:     client, err := ethclient.Dial("http://127.0.0.1:8545")
 44:     if err != nil {
 45:         log.Fatal(err)
 46:     }
 47: 
 48:     buf, err := ioutil.ReadFile("cfg.json")
 49:     if err != nil {
 50:         fmt.Fprintf(os.Stderr, "Unable to open cfg.json for read.  Error:%s\n", err)
 51:         os.Exit(1)
 52:     }
 53:     var cfg CfgType
 54:     err = json.Unmarshal(buf, &cfg)
 55:     if err != nil {
 56:         fmt.Fprintf(os.Stderr, "Unable to parse cfg.json.  Error:%s\n", err)
 57:         os.Exit(1)
 58:     }
 59: 
 60:     contractAddress := common.HexToAddress(cfg.Addrs["Simple777Token"])
 61:     query := ethereum.FilterQuery{
 62:         FromBlock: big.NewInt(5143020),
 63:         ToBlock:   big.NewInt(10000000),
 64:         Addresses: []common.Address{
 65:             contractAddress,
 66:         },
 67:     }
 68: 
 69:     logs, err := client.FilterLogs(context.Background(), query)
 70:     if err != nil {
 71:         log.Fatal(err)
 72:     }
 73: 
 74:     contractAbi, err := abi.JSON(strings.NewReader(string(simple777.TokenABI)))
 75:     if err != nil {
 76:         log.Fatal(err)
 77:     }
 78: 
 79:     logTransferSig := []byte("Transfer(address,address,uint256)")
 80:     LogApprovalSig := []byte("Approval(address,address,uint256)")
 81:     logTransferSigHash := crypto.Keccak256Hash(logTransferSig)
 82:     logApprovalSigHash := crypto.Keccak256Hash(LogApprovalSig)
 83: 
 84:     for _, vLog := range logs {
 85:         fmt.Printf("Log Block Number: %d\n", vLog.BlockNumber)
 86:         fmt.Printf("Log Index: %d\n", vLog.Index)
 87: 
 88:         switch vLog.Topics[0].Hex() {
 89:         case logTransferSigHash.Hex():
 90:             fmt.Printf("Log Name: Transfer\n")
 91: 
 92:             var transferEvent LogTransfer
 93: 
 94:             err := contractAbi.Unpack(&transferEvent, "Transfer", vLog.Data)
 95:             if err != nil {
 96:                 log.Fatal(err)
 97:             }
 98: 
 99:             transferEvent.From = common.HexToAddress(vLog.Topics[1].Hex())
100:             transferEvent.To = common.HexToAddress(vLog.Topics[2].Hex())
101: 
102:             fmt.Printf("From: %s\n", transferEvent.From.Hex())
103:             fmt.Printf("To: %s\n", transferEvent.To.Hex())
104:             fmt.Printf("Tokens: %s\n", transferEvent.Tokens.String())
105: 
106:         case logApprovalSigHash.Hex():
107:             fmt.Printf("Log Name: Approval\n")
108: 
109:             var approvalEvent LogApproval
110: 
111:             err := contractAbi.Unpack(&approvalEvent, "Approval", vLog.Data)
112:             if err != nil {
113:                 log.Fatal(err)
114:             }
115: 
116:             approvalEvent.TokenOwner = common.HexToAddress(vLog.Topics[1].Hex())
117:             approvalEvent.Spender = common.HexToAddress(vLog.Topics[2].Hex())
118: 
119:             fmt.Printf("Token Owner: %s\n", approvalEvent.TokenOwner.Hex())
120:             fmt.Printf("Spender: %s\n", approvalEvent.Spender.Hex())
121:             fmt.Printf("Tokens: %s\n", approvalEvent.Tokens.String())
122:         }
123: 
124:         fmt.Printf("\n\n")
125:     }
126: }
