  1: package main
  2: 
  3: import (
  4:     "context"
  5:     "fmt"
  6:     "log"
  7:     "math/big"
  8:     "strconv"
  9:     "strings"
 10: 
 11:     exchange "github.com/Univ-Wyo-Education/S22-4010/class/lect/37/eth/contracts_0xprotocol" // for demo
 12:     "github.com/ethereum/go-ethereum"
 13:     "github.com/ethereum/go-ethereum/accounts/abi"
 14:     "github.com/ethereum/go-ethereum/common"
 15:     "github.com/ethereum/go-ethereum/common/hexutil"
 16:     "github.com/ethereum/go-ethereum/ethclient"
 17: )
 18: 
 19: // LogFill ...
 20: type LogFill struct {
 21:     Maker                  common.Address
 22:     Taker                  common.Address
 23:     FeeRecipient           common.Address
 24:     MakerToken             common.Address
 25:     TakerToken             common.Address
 26:     FilledMakerTokenAmount *big.Int
 27:     FilledTakerTokenAmount *big.Int
 28:     PaidMakerFee           *big.Int
 29:     PaidTakerFee           *big.Int
 30:     Tokens                 [32]byte
 31:     OrderHash              [32]byte
 32: }
 33: 
 34: // LogCancel ...
 35: type LogCancel struct {
 36:     Maker                     common.Address
 37:     FeeRecipient              common.Address
 38:     MakerToken                common.Address
 39:     TakerToken                common.Address
 40:     CancelledMakerTokenAmount *big.Int
 41:     CancelledTakerTokenAmount *big.Int
 42:     Tokens                    [32]byte
 43:     OrderHash                 [32]byte
 44: }
 45: 
 46: // LogError ...
 47: type LogError struct {
 48:     ErrorID   uint8
 49:     OrderHash [32]byte
 50: }
 51: 
 52: func main() {
 53:     client, err := ethclient.Dial("https://cloudflare-eth.com")
 54:     if err != nil {
 55:         log.Fatal(err)
 56:     }
 57: 
 58:     // 0x Protocol Exchange smart contract address
 59:     contractAddress := common.HexToAddress("0x12459C951127e0c374FF9105DdA097662A027093")
 60:     query := ethereum.FilterQuery{
 61:         FromBlock: big.NewInt(6383482),
 62:         ToBlock:   big.NewInt(6383488),
 63:         Addresses: []common.Address{
 64:             contractAddress,
 65:         },
 66:     }
 67: 
 68:     logs, err := client.FilterLogs(context.Background(), query)
 69:     if err != nil {
 70:         log.Fatal(err)
 71:     }
 72: 
 73:     contractAbi, err := abi.JSON(strings.NewReader(string(exchange.ExchangeABI)))
 74:     if err != nil {
 75:         log.Fatal(err)
 76:     }
 77: 
 78:     // NOTE: keccak256("LogFill(address,address,address,address,address,uint256,uint256,uint256,uint256,bytes32,bytes32)")
 79:     logFillEvent := common.HexToHash("0d0b9391970d9a25552f37d436d2aae2925e2bfe1b2a923754bada030c498cb3")
 80: 
 81:     // NOTE: keccak256("LogCancel(address,address,address,address,uint256,uint256,bytes32,bytes32)")
 82:     logCancelEvent := common.HexToHash("67d66f160bc93d925d05dae1794c90d2d6d6688b29b84ff069398a9b04587131")
 83: 
 84:     // NOTE: keccak256("LogError(uint8,bytes32)")
 85:     logErrorEvent := common.HexToHash("36d86c59e00bd73dc19ba3adfe068e4b64ac7e92be35546adeddf1b956a87e90")
 86: 
 87:     for _, vLog := range logs {
 88:         fmt.Printf("Log Block Number: %d\n", vLog.BlockNumber)
 89:         fmt.Printf("Log Index: %d\n", vLog.Index)
 90: 
 91:         switch vLog.Topics[0].Hex() {
 92:         case logFillEvent.Hex():
 93:             fmt.Printf("Log Name: LogFill\n")
 94: 
 95:             var fillEvent LogFill
 96: 
 97:             err := contractAbi.Unpack(&fillEvent, "LogFill", vLog.Data)
 98:             if err != nil {
 99:                 log.Fatal(err)
100:             }
101: 
102:             fillEvent.Maker = common.HexToAddress(vLog.Topics[1].Hex())
103:             fillEvent.FeeRecipient = common.HexToAddress(vLog.Topics[2].Hex())
104:             fillEvent.Tokens = vLog.Topics[3]
105: 
106:             fmt.Printf("Maker: %s\n", fillEvent.Maker.Hex())
107:             fmt.Printf("Taker: %s\n", fillEvent.Taker.Hex())
108:             fmt.Printf("Fee Recipient: %s\n", fillEvent.FeeRecipient.Hex())
109:             fmt.Printf("Maker Token: %s\n", fillEvent.MakerToken.Hex())
110:             fmt.Printf("Taker Token: %s\n", fillEvent.TakerToken.Hex())
111:             fmt.Printf("Filled Maker Token Amount: %s\n", fillEvent.FilledMakerTokenAmount.String())
112:             fmt.Printf("Filled Taker Token Amount: %s\n", fillEvent.FilledTakerTokenAmount.String())
113:             fmt.Printf("Paid Maker Fee: %s\n", fillEvent.PaidMakerFee.String())
114:             fmt.Printf("Paid Taker Fee: %s\n", fillEvent.PaidTakerFee.String())
115:             fmt.Printf("Tokens: %s\n", hexutil.Encode(fillEvent.Tokens[:]))
116:             fmt.Printf("Order Hash: %s\n", hexutil.Encode(fillEvent.OrderHash[:]))
117: 
118:         case logCancelEvent.Hex():
119:             fmt.Printf("Log Name: LogCancel\n")
120: 
121:             var cancelEvent LogCancel
122: 
123:             err := contractAbi.Unpack(&cancelEvent, "LogCancel", vLog.Data)
124:             if err != nil {
125:                 log.Fatal(err)
126:             }
127: 
128:             cancelEvent.Maker = common.HexToAddress(vLog.Topics[1].Hex())
129:             cancelEvent.FeeRecipient = common.HexToAddress(vLog.Topics[2].Hex())
130:             cancelEvent.Tokens = vLog.Topics[3]
131: 
132:             fmt.Printf("Maker: %s\n", cancelEvent.Maker.Hex())
133:             fmt.Printf("Fee Recipient: %s\n", cancelEvent.FeeRecipient.Hex())
134:             fmt.Printf("Maker Token: %s\n", cancelEvent.MakerToken.Hex())
135:             fmt.Printf("Taker Token: %s\n", cancelEvent.TakerToken.Hex())
136:             fmt.Printf("Cancelled Maker Token Amount: %s\n", cancelEvent.CancelledMakerTokenAmount.String())
137:             fmt.Printf("Cancelled Taker Token Amount: %s\n", cancelEvent.CancelledTakerTokenAmount.String())
138:             fmt.Printf("Tokens: %s\n", hexutil.Encode(cancelEvent.Tokens[:]))
139:             fmt.Printf("Order Hash: %s\n", hexutil.Encode(cancelEvent.OrderHash[:]))
140: 
141:         case logErrorEvent.Hex():
142:             fmt.Printf("Log Name: LogError\n")
143: 
144:             errorID, err := strconv.ParseInt(vLog.Topics[1].Hex(), 16, 64)
145:             if err != nil {
146:                 log.Fatal(err)
147:             }
148: 
149:             errorEvent := &LogError{
150:                 ErrorID:   uint8(errorID),
151:                 OrderHash: vLog.Topics[2],
152:             }
153: 
154:             fmt.Printf("Error ID: %d\n", errorEvent.ErrorID)
155:             fmt.Printf("Order Hash: %s\n", hexutil.Encode(errorEvent.OrderHash[:]))
156:         }
157: 
158:         fmt.Printf("\n\n")
159:     }
160: }
