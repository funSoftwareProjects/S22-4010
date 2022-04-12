  1: package main
  2: 
  3: // MIT Licensed -- Based on original code
  4: // https://goethereumbook.org/en/event-read/
  5: // the code has been fixed to work with 8.1 solc and Eth 1.10.x
  6: 
  7: import (
  8:     "context"
  9:     "fmt"
 10:     "log"
 11:     "math/big"
 12:     "strings"
 13: 
 14:     "github.com/ethereum/go-ethereum"
 15:     "github.com/ethereum/go-ethereum/accounts/abi"
 16:     "github.com/ethereum/go-ethereum/common"
 17:     "github.com/ethereum/go-ethereum/crypto"
 18:     "github.com/ethereum/go-ethereum/ethclient"
 19: 
 20:     gen_event "github.com/Univ-Wyo-Education/S22-4010/class/lect/22/scan-event/eth/contracts"
 21: )
 22: 
 23: // These are the values pulled in from ./cfg.json file.
 24: type GlobalConfig struct {
 25:     ContractAddress string   `json:"contract_address"`
 26:     ClientWSSUrl    string   `json:"client_wss_url"`
 27:     DbFlags         []string `json:"db_flags"`
 28: }
 29: 
 30: var gCfg GlobalConfig
 31: var DbOn map[string]bool = make(map[string]bool)
 32: 
 33: func main() {
 34: 
 35:     // --------------------------------------------------------------------------------------
 36:     // Read global config
 37:     // --------------------------------------------------------------------------------------
 38:     ReadJson("cfg.json", &gCfg)
 39:     if len(gCfg.DbFlags) > 0 {
 40:         for _, x := range gCfg.DbFlags {
 41:             DbOn[x] = true
 42:         }
 43:     }
 44: 
 45:     for _, k := range gCfg.DbFlags {
 46:         DbOn[k] = true
 47:     }
 48: 
 49:     if DbOn["dump-global-config"] {
 50:         fmt.Printf("Global Config:%s\n", SVarI(gCfg))
 51:     }
 52: 
 53:     client, err := ethclient.Dial(gCfg.ClientWSSUrl)
 54:     if err != nil {
 55:         log.Fatal(err)
 56:     }
 57: 
 58:     // --------------------------------------------------------------------------------------
 59:     // Process contract
 60:     // --------------------------------------------------------------------------------------
 61:     contractAddress := common.HexToAddress(gCfg.ContractAddress)
 62:     query := ethereum.FilterQuery{
 63:         FromBlock: big.NewInt(2394201),
 64:         ToBlock:   big.NewInt(2394201),
 65:         Addresses: []common.Address{
 66:             contractAddress,
 67:         },
 68:     }
 69: 
 70:     // --------------------------------------------------------------------------------------
 71:     // Search Chain / Logs
 72:     // --------------------------------------------------------------------------------------
 73:     logs, err := client.FilterLogs(context.Background(), query)
 74:     if err != nil {
 75:         log.Fatal(err)
 76:     }
 77: 
 78:     // Generated Code -- Pull in the ABI for the contract.  contractAbi, err := abi.JSON(strings.NewReader(string(gen_event.StoreABI)))
 79:     contractAbi, err := abi.JSON(strings.NewReader(string(gen_event.GenEventMetaData.ABI))) // xyzzy
 80:     if err != nil {
 81:         log.Fatal(err)
 82:     }
 83: 
 84:     for _, vLog := range logs {
 85:         fmt.Printf("0x%x\n", vLog.BlockHash.Hex()) // 0x3404b8c050aa0aacd0223e91b5c32fee6400f357764771d0684fa7b3f448f1a8
 86:         fmt.Printf("%v\n", vLog.BlockNumber)       // 2394201
 87:         fmt.Printf("0x%x\n", vLog.TxHash.Hex())    // 0x280201eda63c9ff6f305fcee51d5eb86167fab40ca3108ec784e8652a0e2b1a6
 88: 
 89:         event := struct {
 90:             Key   [32]byte
 91:             Value [32]byte
 92:         }{}
 93:         _, err := contractAbi.Unpack("DataSet", vLog.Data) // err := contractAbi.Unpack(&event, "DataSet", vLog.Data) // xyzzy
 94:         if err != nil {
 95:             log.Fatal(err)
 96:         }
 97: 
 98:         fmt.Printf("0x%x\n", string(event.Key[:]))
 99:         fmt.Printf("0x%x\n", string(event.Value[:]))
100: 
101:         var topics [4]string
102:         for i := range vLog.Topics {
103:             topics[i] = vLog.Topics[i].Hex()
104:         }
105: 
106:         fmt.Printf(topics[0]) // 0xe79e73da417710ae99aa2088575580a60415d359acfad9cdd3382d59c80281d4
107:     }
108: 
109:     eventSignature := []byte("DataSet(bytes32,bytes32)")
110:     hash := crypto.Keccak256Hash(eventSignature)
111:     fmt.Printf("%s\n", hash.Hex()) // 0xe79e73
112: }
