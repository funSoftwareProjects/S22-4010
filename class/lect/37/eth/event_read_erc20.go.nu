  1: package main
  2: 
  3: import (
  4:     "context"
  5:     "fmt"
  6:     "log"
  7:     "math/big"
  8:     "strings"
  9: 
 10:     // token "./contracts_erc20" // for demo
 11:     token "github.com/Univ-Wyo-Education/S22-4010/class/lect/37/eth/contracts_erc20"
 12:     "github.com/ethereum/go-ethereum"
 13:     "github.com/ethereum/go-ethereum/accounts/abi"
 14:     "github.com/ethereum/go-ethereum/common"
 15:     "github.com/ethereum/go-ethereum/crypto"
 16:     "github.com/ethereum/go-ethereum/ethclient"
 17: )
 18: 
 19: // LogTransfer ..
 20: type LogTransfer struct {
 21:     From   common.Address
 22:     To     common.Address
 23:     Tokens *big.Int
 24: }
 25: 
 26: // LogApproval ..
 27: type LogApproval struct {
 28:     TokenOwner common.Address
 29:     Spender    common.Address
 30:     Tokens     *big.Int
 31: }
 32: 
 33: func main() {
 34:     client, err := ethclient.Dial("https://cloudflare-eth.com")
 35:     if err != nil {
 36:         log.Fatal(err)
 37:     }
 38: 
 39:     // 0x Protocol (ZRX) token address
 40:     contractAddress := common.HexToAddress("0xe41d2489571d322189246dafa5ebde1f4699f498")
 41:     query := ethereum.FilterQuery{
 42:         FromBlock: big.NewInt(6383820),
 43:         ToBlock:   big.NewInt(6383840),
 44:         Addresses: []common.Address{
 45:             contractAddress,
 46:         },
 47:     }
 48: 
 49:     logs, err := client.FilterLogs(context.Background(), query)
 50:     if err != nil {
 51:         log.Fatal(err)
 52:     }
 53: 
 54:     contractAbi, err := abi.JSON(strings.NewReader(string(token.TokenABI)))
 55:     if err != nil {
 56:         log.Fatal(err)
 57:     }
 58: 
 59:     logTransferSig := []byte("Transfer(address,address,uint256)")
 60:     LogApprovalSig := []byte("Approval(address,address,uint256)")
 61:     logTransferSigHash := crypto.Keccak256Hash(logTransferSig)
 62:     logApprovalSigHash := crypto.Keccak256Hash(LogApprovalSig)
 63: 
 64:     for _, vLog := range logs {
 65:         fmt.Printf("Log Block Number: %d\n", vLog.BlockNumber)
 66:         fmt.Printf("Log Index: %d\n", vLog.Index)
 67: 
 68:         switch vLog.Topics[0].Hex() {
 69:         case logTransferSigHash.Hex():
 70:             fmt.Printf("Log Name: Transfer\n")
 71: 
 72:             var transferEvent LogTransfer
 73: 
 74:             err := contractAbi.Unpack(&transferEvent, "Transfer", vLog.Data)
 75:             if err != nil {
 76:                 log.Fatal(err)
 77:             }
 78: 
 79:             transferEvent.From = common.HexToAddress(vLog.Topics[1].Hex())
 80:             transferEvent.To = common.HexToAddress(vLog.Topics[2].Hex())
 81: 
 82:             fmt.Printf("From: %s\n", transferEvent.From.Hex())
 83:             fmt.Printf("To: %s\n", transferEvent.To.Hex())
 84:             fmt.Printf("Tokens: %s\n", transferEvent.Tokens.String())
 85: 
 86:         case logApprovalSigHash.Hex():
 87:             fmt.Printf("Log Name: Approval\n")
 88: 
 89:             var approvalEvent LogApproval
 90: 
 91:             err := contractAbi.Unpack(&approvalEvent, "Approval", vLog.Data)
 92:             if err != nil {
 93:                 log.Fatal(err)
 94:             }
 95: 
 96:             approvalEvent.TokenOwner = common.HexToAddress(vLog.Topics[1].Hex())
 97:             approvalEvent.Spender = common.HexToAddress(vLog.Topics[2].Hex())
 98: 
 99:             fmt.Printf("Token Owner: %s\n", approvalEvent.TokenOwner.Hex())
100:             fmt.Printf("Spender: %s\n", approvalEvent.Spender.Hex())
101:             fmt.Printf("Tokens: %s\n", approvalEvent.Tokens.String())
102:         }
103: 
104:         fmt.Printf("\n\n")
105:     }
106: }
